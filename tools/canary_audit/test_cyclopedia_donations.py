"""Compile the actual single-world donation service with a transactional SQL test double.
Run in an MSVC developer shell. No live server, client or database is used.
"""
from pathlib import Path
import re, subprocess, tempfile
from validate_cyclopedia_donations import decode_response
root = Path(__file__).resolve().parents[2]
include = root / "build/windows-release/vcpkg_installed/x64-windows-static-release/include"
import os
include = Path(os.environ.get("CANARY_AUDIT_INCLUDE", include))
header = re.sub(r'^#include.*$', '', (root/'src/game/cyclopedia_donations.hpp').read_text(), flags=re.M)
service = re.sub(r'^\s*#include.*$', '', (root/'src/game/cyclopedia_donations.cpp').read_text(), flags=re.M)
protocol = (root/'src/server/network/protocol/protocolgame.cpp').read_text(encoding='utf-8-sig')
sender = protocol[protocol.index('void ProtocolGame::sendCyclopediaMapDonations()'):protocol.index('void ProtocolGame::sendCyclopediaMapSetDiscoveryArea(')]
spawn = (root/'src/creatures/monsters/spawns/spawn_monster.cpp').read_text(encoding='utf-8-sig')
polling = spawn[spawn.index('uint32_t SpawnMonster::getInterval() const'):spawn.index('void SpawnMonster::startSpawnMonsterCheck()')]
expression = spawn.split('const auto effectiveInterval = ', 1)[1].split(';', 1)[0]
spawn_checks = 'struct SpawnMonster {uint32_t interval;uint32_t getInterval()const;};' + polling + 'uint32_t effectiveInterval(Position position,uint32_t interval){struct {Position pos;uint32_t interval;} sb{position,interval};constexpr uint32_t MONSTER_MINSPAWN_INTERVAL=1000;return ' + expression + ';}'

prefix = r'''
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <limits>
#include <map>
#include <memory>
#include <regex>
#include <ranges>
#include <string>
#include <vector>
#include <iostream>
#include <nlohmann/json.hpp>
#define FMT_HEADER_ONLY
#include <fmt/format.h>
struct WorldId {uint32_t value;bool operator==(const WorldId&)const=default;};
struct Position {uint16_t x,y;uint8_t z;};
struct Logger {template<class...T>void error(T&&...){}template<class...T>void info(T&&...){}} logger;
Logger& g_logger(){return logger;}
'''
fixtures = r'''
using Row=std::map<std::string,uint64_t>;
struct DBResult {std::vector<Row> rows;size_t pos=0;template<class T>T getNumber(const std::string& n)const{return static_cast<T>(rows.at(pos).at(n));}bool next(){return ++pos<rows.size();}};
std::vector<uint64_t> numbers(const std::string& raw){const auto q=std::regex_replace(raw,std::regex("0=0"),"0");std::vector<uint64_t> v;std::regex r("[0-9]+");for(std::sregex_iterator i(q.begin(),q.end(),r),e;i!=e;++i)v.push_back(std::stoull(i->str()));return v;}
struct Database {
std::map<std::pair<uint32_t,uint16_t>,Row> areas;std::map<uint32_t,uint64_t> cycles;std::map<uint32_t,Row> players;std::vector<Row> logs;std::string fail;
bool executeQuery(const std::string& q){
 if(!fail.empty()&&q.find(fail)!=std::string::npos)return false;
 if(q.starts_with("CREATE"))return true;
 auto n=numbers(q);
 if(q.starts_with("INSERT IGNORE INTO `cyclopedia_donations`")){areas.try_emplace({n[0],n[1]},Row{{"area_id",n[1]},{"amount",0},{"active",0}});return true;}
 if(q.starts_with("INSERT IGNORE INTO `cyclopedia_donation_cycles`")){cycles.try_emplace(n[0],0);return true;}
 if(q.starts_with("UPDATE `players`")){auto& p=players.at(n[1]);if(p["world_id"]!=n[2])return false;p["balance"]=n[0];return true;}
 if(q.starts_with("UPDATE `cyclopedia_donations` SET `amount`")){areas.at({n[1],n[2]})["amount"]=n[0];return true;}
 if(q.starts_with("UPDATE `cyclopedia_donations` SET `active`=0")){for(auto& [key,row]:areas)if(key.first==n[1])row["active"]=0;return true;}
 if(q.starts_with("UPDATE `cyclopedia_donations` SET `active`=1")){auto& row=areas.at({n[2],n[3]});row["active"]=1;row["amount"]=0;return true;}
 if(q.starts_with("UPDATE `cyclopedia_donation_cycles`")){cycles[n[1]]=n[0];return true;}
 if(q.starts_with("INSERT INTO `cyclopedia_donation_log`")){logs.push_back({{"world_id",n[0]},{"player_id",n[1]},{"area_id",n[2]},{"amount",n[3]}});return true;}
 throw std::runtime_error("Unhandled SQL: "+q);
}
std::shared_ptr<DBResult> storeQuery(const std::string& q){
 if(!fail.empty()&&q.find(fail)!=std::string::npos)return {};
 auto n=numbers(q);auto result=std::make_shared<DBResult>();
 if(q.starts_with("SELECT `balance`")){auto p=players.find(n[0]);if(p!=players.end()&&p->second["world_id"]==n[1]&&p->second["account_id"]==n[2])result->rows.push_back(p->second);}
 else if(q.starts_with("SELECT `last_day`")){if(cycles.contains(n[0]))result->rows.push_back({{"last_day",cycles[n[0]]}});}
 else if(q.starts_with("SELECT `amount`,`active`")){auto p=areas.find({n[0],n[1]});if(p!=areas.end())result->rows.push_back(p->second);}
 else if(q.starts_with("SELECT `area_id`")){for(auto& [key,row]:areas)if(key.first==n[0])result->rows.push_back(row);if(q.find("ORDER BY")!=std::string::npos)std::sort(result->rows.begin(),result->rows.end(),[](const Row&a,const Row&b){return a.at("amount")!=b.at("amount")?a.at("amount")>b.at("amount"):a.at("area_id")<b.at("area_id");});}
 else throw std::runtime_error("Unhandled query: "+q);
 return result->rows.empty()?nullptr:result;
}
} database;
Database& g_database(){return database;}
struct DBTransaction {template<class F>static bool executeWithinTransactionRollbackOnFailure(F f){auto before=database;if(!f()){database=before;return false;}return true;}};
struct Player {WorldId worldId;uint32_t id=23,account=2;uint64_t balance=50000000;bool removed=false;int messages=0;WorldId getWorldId()const{return worldId;}bool isRemoved()const{return removed;}uint32_t getGUID()const{return id;}uint32_t getAccountId()const{return account;}uint64_t getBankBalance()const{return balance;}void setBankBalance(uint64_t v){balance=v;}void sendResourceBalance(int,uint64_t){}void sendCyclopediaMapDonations(){++messages;}};
enum {RESOURCE_BANK};
struct Game {CyclopediaDonations cyclopediaDonations;std::map<uint32_t,std::shared_ptr<Player>> players;Game(uint32_t id):cyclopediaDonations(){}const auto& getPlayers(){return players;}};
struct World {Game gameValue;World(uint32_t id):gameValue(id){}Game& game(){return gameValue;}};
struct Manager {std::map<uint32_t,std::unique_ptr<World>> worlds;World* getWorld(WorldId id){auto i=worlds.find(id.value);return i==worlds.end()?nullptr:i->second.get();}} manager;
Manager& g_worldManager(){return manager;}
Game& g_game(){return manager.getWorld({0})->game();}
namespace IOLoginData {bool fail=false;bool savePlayer(const std::shared_ptr<Player>& p){if(fail)return false;database.players[p->id]={{"balance",p->balance},{"world_id",p->worldId.value},{"account_id",p->account}};return true;}}
struct NetworkMessage {std::vector<uint8_t> bytes;void addByte(uint8_t v){bytes.push_back(v);}template<class T>void add(T v){for(size_t i=0;i<sizeof(T);++i)addByte(static_cast<uint64_t>(v)>>(8*i));}};
enum class CyclopediaMapData_t:uint8_t{Donations=9};
uint8_t enumToValue(CyclopediaMapData_t v){return static_cast<uint8_t>(v);}
struct ProtocolGame {std::shared_ptr<Player> player;bool oldProtocol=false,isOTC=false,isOTCR=false;int clientVersion=1525;std::string clientVersionString="15.25.0a00a0d67311e057aa8e659a84cdf51db9c08c03";std::vector<uint8_t> bytes;Game& getWorldGame(){return manager.getWorld(player->worldId)->game();}void writeToOutputBuffer(NetworkMessage&m){bytes=m.bytes;}void sendCyclopediaMapDonations();};
int checks=0;void check(bool ok,const char* text){if(!ok)throw std::runtime_error(text);++checks;}
struct lua_State {bool result=true;};
namespace Lua {void pushBoolean(lua_State* L,bool value){L->result=value;}}
struct GameFunctions {static int luaGameAdvanceCyclopediaDonations(lua_State*);};
'''
main = r'''
int main(int argc,char**argv){try {
manager.worlds[0]=std::make_unique<World>(0);
auto p=std::make_shared<Player>();p->worldId={0};g_game().players[23]=p;
auto& a=g_game().cyclopediaDonations;
check(a.load(),"load");
check(!a.donate(p,5,100).empty()&&!a.donate(p,65535,100).empty(),"invalid/rejected area");
check(!a.donate(p,24,0).empty()&&!a.donate(p,24,UINT32_MAX).empty(),"invalid amount");
p->balance=99;check(!a.donate(p,24,100).empty(),"insufficient balance");p->balance=50000000;
IOLoginData::fail=true;check(!a.donate(p,24,100).empty()&&p->balance==50000000,"save failure charged");IOLoginData::fail=false;
database.fail="INSERT INTO `cyclopedia_donation_log`";
check(!a.donate(p,24,100).empty()&&p->balance==50000000&&database.players[23]["balance"]==50000000&&database.areas[{0,24}]["amount"]==0,"transaction rollback");database.fail.clear();
check(a.donate(p,24,10000000).empty()&&p->balance==40000000,"donation");
check(database.logs.size()==1&&database.areas[{0,24}]["amount"]==10000000,"audit/total");
check(p->messages==1,"broadcast");
check(a.donate(p,3,100).empty(),"loser donation");
database.cycles[0]=day()-1;
CyclopediaDonations beforeSave;check(beforeSave.load()&&beforeSave.entries().at(24).amount==10000000&&!beforeSave.hasActive()&&database.cycles[0]==day()-1,"restart rotated pending cycle");
check(a.advance(),"scheduled rotation");
check(a.entries().at(24).active&&a.entries().at(24).amount==0&&a.entries().at(3).amount==100,"winner reset/loser retention");
check(!a.donate(p,24,1).empty(),"active area donation");check(!a.advance(),"duplicate rotation");
CyclopediaDonations restart;check(restart.load()&&restart.entries().at(24).active&&restart.entries().at(3).amount==100,"restart persistence");
database.cycles[0]=day()-1;CyclopediaDonations laterRestart;check(laterRestart.load()&&laterRestart.entries().at(24).active&&database.cycles[0]==day()-1,"old cycle rotated on load");
std::ifstream input("data/XML/cyclopedia-donation-areas.json");nlohmann::json doc;input>>doc;Position pos{};
for(const auto& area:doc["areas"])if(area["id"]==24){auto r=area["runs"][0];pos={r[2].get<uint16_t>(),r[1].get<uint16_t>(),r[0].get<uint8_t>()};break;}
check(a.improved(pos)&&!a.improved(Position{0,0,0}),"exact mask");
check(effectiveInterval(pos,16000)==8000&&effectiveInterval(Position{0,0,0},16000)==16000&&effectiveInterval(pos,1000)==1000,"dynamic interval/bounds");
check(SpawnMonster{30000}.getInterval()==15000,"polling interval");
ProtocolGame protocol;protocol.player=p;protocol.sendCyclopediaMapDonations();std::ofstream output(argv[1],std::ios::binary);output.write(reinterpret_cast<const char*>(protocol.bytes.data()),protocol.bytes.size());output.close();
check(protocol.bytes.size()==11+28*11,"wire count");protocol.bytes.clear();protocol.oldProtocol=true;protocol.sendCyclopediaMapDonations();check(protocol.bytes.empty(),"legacy packet");
check(a.advance()&&!a.hasActive()&&a.entries().at(3).amount==100,"expiry and retention");database.areas[{0,24}]["amount"]=INT64_MAX;check(!a.donate(p,24,1).empty(),"overflow");
std::cout<<"PASS: "<<checks<<" actual donation service/sender checks\n";
}catch(const std::exception& error){std::cerr<<error.what()<<"\n";return 1;}}
'''
with tempfile.TemporaryDirectory(prefix="canary-donations-test-") as folder:
    folder = Path(folder)
    source = folder / "donations.cpp"
    source.write_text(prefix + header + fixtures + service + sender + spawn_checks + main, encoding="utf-8")
    subprocess.run(["cl", "/nologo", "/EHsc", "/std:c++20", "/utf-8", str(source),
                    "/I" + str(include), "/Fo" + str(folder / "donations.obj"),
                    "/Fe" + str(folder / "donations.exe")], cwd=folder, check=True)
    packet = folder / "response.bin"
    subprocess.run([str(folder / "donations.exe"), str(packet)], cwd=root, check=True)
    decoded = decode_response(packet.read_bytes())
    assert decoded["global_u64"] == 10000000
    assert len(decoded["areas"]) == 28
    assert next(a for a in decoded["areas"] if a["area_id"] == 24)["flag_raw"] == 1
    print("PASS: independent walker consumed complete actual sender response (28 areas)")
