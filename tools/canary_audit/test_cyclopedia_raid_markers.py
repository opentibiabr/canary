"""Compile the actual raid registry/sender methods against small upstream single-world fixtures.

Run from the maintained MSVC developer environment. Does not load the server,
connect a client, spawn a raid or modify the database.
"""

from pathlib import Path
import subprocess
import tempfile

from validate_cyclopedia_raid_packet import decode_packet


ROOT = Path(__file__).resolve().parents[2]


def method(path, start, end):
    source = (ROOT / path).read_text(encoding="utf-8-sig")
    offset = source.index(start)
    return source[offset:source.index(end, offset)]


registry = method("src/lua/creature/raids.cpp", "bool Raids::addMapMarker(", "void Raids::clear()")
sender = method("src/server/network/protocol/protocolgame.cpp", "void ProtocolGame::sendCyclopediaRaidMarker(",
                "void ProtocolGame::sendCyclopediaMapDiscoveryData(")
player_sender = method("src/creatures/players/player.cpp", "void Player::sendCyclopediaRaidMarker(",
                       "void Player::sendCyclopediaDiscovery(")

PREFIX = r'''
#include <map>
#include <memory>
#include <vector>
#include <string>
#include <tuple>
#include <fstream>
#include <cstdint>
#include <stdexcept>
struct Position {uint16_t x,y;uint8_t z;bool operator<(const Position& p)const{return std::tie(x,y,z)<std::tie(p.x,p.y,p.z);}};
struct NetworkMessage {std::vector<uint8_t> bytes;void addByte(uint8_t b){bytes.push_back(b);}void addPosition(const Position& p){addByte(p.x);addByte(p.x>>8);addByte(p.y);addByte(p.y>>8);addByte(p.z);}};
enum class CyclopediaMapData_t:uint8_t {ActiveRaid=2};
uint8_t enumToValue(CyclopediaMapData_t t){return static_cast<uint8_t>(t);}
struct ProtocolGame {bool player=true,oldProtocol=false,isOTC=false,isOTCR=false;int clientVersion=1525;std::string clientVersionString="15.25.0a00a0d67311e057aa8e659a84cdf51db9c08c03";std::vector<std::vector<uint8_t>> sent;void writeToOutputBuffer(NetworkMessage& m){sent.push_back(m.bytes);}void sendCyclopediaRaidMarker(const Position&,bool);};
struct Monster {int world;uint32_t id;bool removed=false;int health=100;bool isRemoved()const{return removed;}int getHealth()const{return health;}int getWorldId()const{return world;}uint32_t getID()const{return id;}};
struct Player {std::shared_ptr<ProtocolGame> client=std::make_shared<ProtocolGame>();void sendCyclopediaRaidMarker(const Position&,bool)const;};
struct Game {std::map<uint32_t,std::shared_ptr<Monster>> monsters;std::map<uint32_t,std::shared_ptr<Player>> players;auto getMonsterByID(uint32_t id){auto it=monsters.find(id);return it==monsters.end()?std::shared_ptr<Monster>():it->second;}const auto& getPlayers()const{return players;}};
Game game;
Game& g_game(){return game;}
struct Raids {std::map<uint32_t,Position> markedMonsters;std::map<Position,uint32_t> mapMarkers;bool addMapMarker(const std::shared_ptr<Monster>&,const Position&);void removeMapMarker(uint32_t);};
void check(bool ok,const char* message){if(!ok)throw std::runtime_error(message);}
'''

MAIN = r'''
int main(){
game.players[10]=std::make_shared<Player>();auto client=game.players[10]->client;
Raids raids;Position position{32331,32182,7};
auto a=std::make_shared<Monster>(Monster{0,1}),b=std::make_shared<Monster>(Monster{0,2});
game.monsters[1]=a;game.monsters[2]=b;
check(!raids.addMapMarker(std::make_shared<Monster>(Monster{0,1}),position),"replaced identity accepted");
check(raids.addMapMarker(a,position)&&client->sent.size()==1,"first add failed");
check(!raids.addMapMarker(a,position),"duplicate identity accepted");
check(raids.addMapMarker(b,position)&&client->sent.size()==1,"overlap duplicated marker");
raids.removeMapMarker(1);check(client->sent.size()==1&&raids.mapMarkers.size()==1,"removed shared pin early");
raids.removeMapMarker(2);check(client->sent.size()==2&&raids.mapMarkers.empty(),"last despawn did not remove pin");
raids.removeMapMarker(2);check(client->sent.size()==2,"duplicate removal emitted packet");
a->health=0;check(!raids.addMapMarker(a,position),"dead spawn accepted");a->health=100;a->removed=true;
check(!raids.addMapMarker(a,position),"removed spawn accepted");a->removed=false;
for(uint32_t id=100;id<4196;++id)raids.markedMonsters.emplace(id,position);
check(!raids.addMapMarker(a,position),"unbounded registry");
ProtocolGame legacy;legacy.oldProtocol=true;legacy.sendCyclopediaRaidMarker(position,true);check(legacy.sent.empty(),"legacy received packet");
ProtocolGame otc;otc.isOTC=true;otc.sendCyclopediaRaidMarker(position,true);check(otc.sent.empty(),"OTC received packet");
ProtocolGame unknown;unknown.clientVersionString="unknown";unknown.sendCyclopediaRaidMarker(position,true);check(unknown.sent.empty(),"unknown build received packet");
for(int i=0;i<2;++i){std::ofstream out(i==0?"add.bin":"remove.bin",std::ios::binary);out.write(reinterpret_cast<const char*>(client->sent[i].data()),client->sent[i].size());}
}
'''

with tempfile.TemporaryDirectory(prefix="canary-raid-marker-test-") as directory:
    temporary = Path(directory)
    source = temporary / "markers.cpp"
    source.write_text(PREFIX + registry + sender + player_sender + MAIN, encoding="utf-8")
    subprocess.run(["cl", "/nologo", "/EHsc", "/std:c++20", str(source),
                    "/Fo" + str(temporary / "markers.obj"),
                    "/Fe" + str(temporary / "markers.exe")], cwd=temporary, check=True)
    subprocess.run([str(temporary / "markers.exe")], cwd=temporary, check=True)
    assert decode_packet((temporary / "add.bin").read_bytes()) == {
        "x": 32331, "y": 32182, "z": 7, "change": "add"}
    assert decode_packet((temporary / "remove.bin").read_bytes())["change"] == "remove"
print("PASS: actual registry/sender: overlap, last removal, identity, dead/removed, bounds, client gates, complete emitted bytes")
