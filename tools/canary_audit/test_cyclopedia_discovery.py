"""Compile real discovery methods/senders with isolated owner/map/SQL fixtures.

Run in MSVC developer environment. This tests code paths, not a connected client.
"""
from pathlib import Path
import re
import subprocess
import tempfile

from validate_cyclopedia_discovery import decode_packet

root=Path(__file__).resolve().parents[2]
include = root / "build/windows-release/vcpkg_installed/x64-windows-static-release/include"
import os
include = Path(os.environ.get("CANARY_AUDIT_INCLUDE", include))
header=re.sub(r'^#include.*$','',(root/'src/creatures/players/components/player_cyclopedia.hpp').read_text(encoding='utf-8-sig'),flags=re.M).replace('private:','public:')
source=(root/'src/creatures/players/components/player_cyclopedia.cpp').read_text(encoding='utf-8-sig')
service=source[source.index('PlayerCyclopedia::PlayerCyclopedia('):source.index('Summary PlayerCyclopedia::getSummary()')]
protocol=(root/'src/server/network/protocol/protocolgame.cpp').read_text(encoding='utf-8-sig')
senders=protocol[protocol.index('void ProtocolGame::sendCyclopediaMapDiscoveryData('):protocol.index('void ProtocolGame::sendCyclopediaMapDonations(')]
senders+=protocol[protocol.index('void ProtocolGame::sendCyclopediaMapSetDiscoveryArea('):protocol.index('void ProtocolGame::sendCyclopediaCharacterNoData(')]

prefix = r'''
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <deque>
#include <fstream>
#include <iostream>
#include <map>
#include <memory>
#include <random>
#include <ranges>
#include <regex>
#include <set>
#include <string>
#include <tuple>
#include <unordered_set>
#include <vector>
#include <nlohmann/json.hpp>
#define FMT_HEADER_ONLY
#include <fmt/format.h>
struct Position {uint16_t x=0,y=0;uint8_t z=0;Position()=default;Position(uint16_t x,uint16_t y,uint8_t z):x(x),y(y),z(z){}bool operator<(const Position&p)const{return std::tie(x,y,z)<std::tie(p.x,p.y,p.z);}};
struct WorldId {uint32_t value;};
int uniform_random(int a,int b){static std::mt19937 random(42);return std::uniform_int_distribution<int>(a,b)(random);}
struct Logger{template<class...T>void error(T&&...){}template<class...T>void info(T&&...){}} logger;
Logger& g_logger(){return logger;}
'''
fixtures = r'''
struct Row {std::map<std::string,uint64_t> numbers;std::string points;};
struct DBResult {std::vector<Row> rows;size_t pos=0;template<class T>T getNumber(const std::string& key)const{return static_cast<T>(rows.at(pos).numbers.at(key));}std::string getString(const std::string&)const{return rows.at(pos).points;}bool next(){return ++pos<rows.size();}};
std::vector<uint64_t> numbers(const std::string&raw){const auto q=std::regex_replace(raw,std::regex("0=0"),"0");std::vector<uint64_t> result;std::regex r("[0-9]+");for(std::sregex_iterator i(q.begin(),q.end(),r),e;i!=e;++i)result.push_back(std::stoull(i->str()));return result;}
struct Database {std::map<std::tuple<uint32_t,uint32_t,uint16_t>,Row> rows;std::map<uint32_t,std::pair<uint32_t,uint32_t>> players;std::string fail;
std::string escapeString(const std::string&s){return "'"+s+"'";}
bool executeQuery(const std::string&q){if(!fail.empty()&&q.find(fail)!=std::string::npos)return false;if(q.starts_with("CREATE"))return true;auto n=numbers(q);
if(q.starts_with("UPDATE")){for(auto&[key,row]:rows)if(std::get<0>(key)==n[1]&&std::get<1>(key)==n[2])row.numbers["active"]=0;return true;}
if(q.starts_with("INSERT")){auto start=q.find('\'');auto end=q.find('\'',start+1);rows[{n[0],n[1],n[2]}]={{{"area_id",n[2]},{"active",1}},q.substr(start+1,end-start-1)};return true;}throw std::runtime_error(q);}
std::shared_ptr<DBResult> storeQuery(const std::string&q){if(!fail.empty()&&q.find(fail)!=std::string::npos)return {};auto n=numbers(q);auto result=std::make_shared<DBResult>();
if(q.starts_with("SELECT `id`")){if(players.contains(n[0])&&players[n[0]]==std::pair<uint32_t,uint32_t>{static_cast<uint32_t>(n[1]),static_cast<uint32_t>(n[2])})result->rows.push_back({{{"id",n[0]}},""});}
else {bool owner=players.contains(n[1])&&players[n[1]]==std::pair<uint32_t,uint32_t>{static_cast<uint32_t>(n[0]),static_cast<uint32_t>(n[2])};std::vector<Row> selected;if(owner)for(auto&[key,row]:rows)if(std::get<0>(key)==n[0]&&std::get<1>(key)==n[1])selected.push_back(row);
if(q.starts_with("SELECT COUNT"))result->rows.push_back({{{"count",selected.size()}},""});else result->rows=selected;}
return result->rows.empty()?nullptr:result;}
} database;
Database& g_database(){return database;}
struct DBTransaction {template<class F>static bool executeWithinTransactionRollbackOnFailure(F f){auto before=database;if(!f()){database=before;return false;}return true;}};
constexpr uint32_t TILESTATE_FLOORCHANGE=1,TILESTATE_TELEPORT=2;
struct Tile {bool getGround(){return true;}bool getHouse(){return false;}bool isMovableBlocking(){return false;}bool hasFlag(uint32_t){return false;}};
struct Map {bool blocked=false;uint16_t blockedFloors=0;bool smallTopFloor=false;std::set<Position> blockedTiles;std::shared_ptr<Tile> getTile(const Position&p){return blocked||(blockedFloors&(1u<<p.z))||blockedTiles.contains(p)||(smallTopFloor&&p.z==5&&(std::abs(int(p.x)-33001)>3||std::abs(int(p.y)-32049)>3))?nullptr:std::make_shared<Tile>();}};
struct Game {Map map;};
struct ProtocolGame;
struct Player {WorldId world;uint32_t id=23,account=2;Position position{32369,32241,7};bool removed=false;Game game;std::shared_ptr<ProtocolGame> client;std::unique_ptr<PlayerCyclopedia> progress;std::vector<std::string> messages;struct Effect{Position position;uint16_t id;bool removed;};std::vector<Effect> effects;void sendMagicEffect(const Position&p,uint16_t id){effects.push_back({p,id,false});}void removeMagicEffect(const Position&p,uint16_t id){effects.push_back({p,id,true});}
Player(WorldId w):world(w),progress(std::make_unique<PlayerCyclopedia>(*this)){}WorldId getWorldId()const{return world;}uint32_t getGUID()const{return id;}uint32_t getAccountId()const{return account;}Position getPosition()const{return position;}bool isRemoved()const{return removed;}Game& getWorldGame(){return game;}auto getClient(){return client;}PlayerCyclopedia& cyclopedia(){return *progress;}void sendTextMessage(int,const std::string&s){messages.push_back(s);}void sendCyclopediaDiscovery()const;};
Game* currentGame = nullptr;
Game& g_game(){return *currentGame;}
enum {MESSAGE_FAILURE, MESSAGE_EVENT_ADVANCE, CONST_ME_PINK_VORTEX=193, CONST_ME_PINK_BEAM=195};
struct NetworkMessage{std::vector<uint8_t> bytes;void addByte(uint8_t v){bytes.push_back(v);}template<class T>void add(T v){for(size_t i=0;i<sizeof(T);++i)addByte(static_cast<uint64_t>(v)>>(8*i));}void addPosition(const Position&p){add<uint16_t>(p.x);add<uint16_t>(p.y);addByte(p.z);}};
enum class CyclopediaMapData_t:uint8_t{DiscoveryData=1,SetDiscoveryArea=5,SetCurrentArea=10};
uint8_t enumToValue(CyclopediaMapData_t v){return static_cast<uint8_t>(v);}
struct ProtocolGame{std::shared_ptr<Player> player;bool oldProtocol=false,isOTC=false,isOTCR=false;int clientVersion=1525;std::string clientVersionString="15.25.0a00a0d67311e057aa8e659a84cdf51db9c08c03";const std::string& getClientVersionString(){return clientVersionString;}std::vector<std::vector<uint8_t>> packets;void writeToOutputBuffer(NetworkMessage&m){packets.push_back(m.bytes);}void sendCyclopediaMapDiscoveryData(uint16_t=0);void sendCyclopediaDiscovery();void sendCyclopediaMapCurrentArea(uint16_t);void sendCyclopediaMapSetDiscoveryArea(uint16_t,uint8_t=1);};
void Player::sendCyclopediaDiscovery()const{if(client)client->sendCyclopediaDiscovery();}
int checks=0;void check(bool ok,const char* text){if(!ok)throw std::runtime_error(text);++checks;}
'''
main = r'''
int main(int argc,char**argv){try {
auto p=std::make_shared<Player>(WorldId{0});currentGame=&p->game;database.players[23]={0,2};
auto protocol=std::make_shared<ProtocolGame>();protocol->player=p;p->client=protocol;auto& d=p->cyclopedia();
check(d.startDiscovery(28).empty(),"start Thais");auto points=d.discoveryPoints();check(points.size()==5,"point count");
for(const auto& point:points)check(discoveryRegions().at(28).contains(point.position),"point outside mask");
auto first=points[0].position;p->position=first;d.onDiscoveryMove(true);check(d.discoveryPoints()[0].state==0,"teleport credited");
database.fail="INSERT";d.onDiscoveryMove(false);check(d.discoveryPoints()[0].state==0,"failed persistence credited");database.fail.clear();d.discoveryNextWrite=0;
for(const auto& point:points){p->position=point.position;d.onDiscoveryMove(false);}
check(std::ranges::all_of(d.discoveryPoints(),[](const auto& point){return point.state==2;}),"completion");
check(d.completedDiscoveryAreas()==std::vector<uint16_t>{28},"completed area");
PlayerCyclopedia relog(*p);check(relog.loadDiscovery()&&relog.completedDiscoveryAreas()==std::vector<uint16_t>{28},"relog persistence");
auto messages=p->messages.size();d.onDiscoveryMove(false);check(p->messages.size()==messages,"completion replay");
d.discoveryNextReset=0;check(!d.startDiscovery(28).empty(),"completed reset");
protocol->packets.clear();protocol->sendCyclopediaDiscovery();check(protocol->packets.size()==3,"snapshot count");
for(size_t i=0;i<3;++i){std::ofstream out(std::string(argv[1])+"/packet"+std::to_string(i)+".bin",std::ios::binary);const auto& raw=protocol->packets[i];out.write(reinterpret_cast<const char*>(raw.data()),raw.size());}
protocol->packets.clear();protocol->oldProtocol=true;protocol->sendCyclopediaDiscovery();check(protocol->packets.empty(),"legacy snapshot");
auto saved=database.rows;auto corrupt=nlohmann::json::parse(database.rows[{0,23,28}].points);corrupt[0][0]=uint64_t{4294967297};database.rows[{0,23,28}].points=corrupt.dump();PlayerCyclopedia invalid(*p);check(!invalid.loadDiscovery(),"oversized coordinate");database.rows=saved;
auto venore=std::make_shared<Player>(WorldId{0});currentGame=&venore->game;venore->id=30;database.players[30]={0,2};auto vp=std::make_shared<ProtocolGame>();vp->player=venore;venore->client=vp;auto& vd=venore->cyclopedia();
for(uint8_t floor:{7,6,5}){venore->position={33001,32049,floor};vd.discoveryNextReset=0;check(vd.startDiscovery(276).empty(),"Venore upper floor start");check(std::ranges::all_of(vd.discoveryPoints(),[&](const auto& point){return point.position.z==floor&&discoveryRegions().at(276).contains(point.position);}),"upper-floor generation");}
PlayerCyclopedia upperRelog(*venore);check(upperRelog.loadDiscovery()&&upperRelog.discoveryPoints()[0].position.z==5,"upper-floor persistence");
venore->position={33001,32049,8};vd.discoveryNextReset=0;check(!vd.startDiscovery(276).empty(),"surface mask leaked underground");
auto before=database.rows;venore->position={33001,32049,6};venore->game.map.blocked=true;vd.discoveryNextReset=0;check(!vd.startDiscovery(276).empty()&&database.rows[{0,30,276}].points==before[{0,30,276}].points,"unreachable reset lost state");
std::cout<<"PASS: "<<checks<<" actual discovery generation, movement, rollback, persistence and sender checks\n";
}catch(const std::exception& error){std::cerr<<error.what()<<"\n";return 1;}}
'''
with tempfile.TemporaryDirectory(prefix='canary-discovery-test-') as folder:
    folder=Path(folder)
    cpp=folder/'discovery.cpp'
    cpp.write_text(prefix+header+fixtures+service+senders+main,encoding='utf-8')
    subprocess.run(['cl','/nologo','/EHsc','/std:c++20','/utf-8',str(cpp),'/I'+str(include),
                    '/Fo'+str(folder/'discovery.obj'),'/Fe'+str(folder/'discovery.exe')],cwd=folder,check=True)
    subprocess.run([str(folder/'discovery.exe'),str(folder)],cwd=root,check=True)
    packets=[decode_packet((folder/f'packet{i}.bin').read_bytes()) for i in range(3)]
    assert next(a for a in packets[0]['areas'] if a['area']==28)['percent_raw']==100
    assert packets[0]['list_a']==[28] and 28 not in packets[0]['list_b']
    assert packets[1]['total']==5 and all(p['state']==1 for p in packets[1]['points'])
    assert packets[2]['subtype']==10
    print('PASS: independent walker consumed all three packets emitted by actual discovery senders')
