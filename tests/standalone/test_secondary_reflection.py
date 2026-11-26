"""Exercise the production secondary-reflection block without a server build.

Run from the repository root:
    python tests/standalone/test_secondary_reflection.py --compiler g++

The C++ block is read unchanged from Game::combatBlockHit. Creature lookups
are controlled; reflected values, channel selection and guards execute as C++.
"""

import argparse
from pathlib import Path
import subprocess
import tempfile


def reflection_block(source):
    function_start = source.index("bool Game::combatBlockHit(")
    marker = "if (!damage.extension && attacker && target->getMonster()) {"
    start = source.index(marker, function_start)
    opening = source.index("{", start)
    depth = 1
    end = opening + 1
    while depth:
        if source[end] == "{":
            depth += 1
        elif source[end] == "}":
            depth -= 1
        end += 1
    return source[start:end]


PREAMBLE = r"""
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>

constexpr int COMBAT_NONE = 0, COMBAT_PHYSICALDAMAGE = 1, COMBAT_FIREDAMAGE = 2;
struct Component { int type = COMBAT_NONE; int32_t value = 0; };
struct Damage {
    Component primary, secondary;
    bool extension = false;
    std::string exString;
};
struct Params { int combatType = COMBAT_NONE; bool aggressive = false; };
struct Creature {
    bool monster = true;
    int32_t percent = 0, flat = 0, maxHealth = 10000;
    bool getMonster() const { return monster; }
    int32_t getReflectPercent(int type, bool) const {
        if (type != COMBAT_FIREDAMAGE) throw std::runtime_error("wrong reflect type");
        return percent;
    }
    int32_t getReflectFlat(int type, bool) const {
        if (type != COMBAT_FIREDAMAGE) throw std::runtime_error("wrong flat type");
        return flat;
    }
    int32_t getMaxHealth() const { return maxHealth; }
};
struct Result { Damage damage; Params params; bool canReflect; };
Result reflect(Damage damage, const Creature *attacker, const Creature *target,
               Damage damageReflected = {}, bool canReflect = false) {
    Params damageReflectedParams;
"""

CASES = r"""
    return {damageReflected, damageReflectedParams, canReflect};
}
void check(bool value, const char *message) {
    if (!value) throw std::runtime_error(message);
}
void runChecks() {
    Creature attacker, target;
    target.percent = 50;
    Damage hit;
    hit.primary = {COMBAT_PHYSICALDAMAGE, -100};
    hit.secondary = {COMBAT_FIREDAMAGE, -40};
    auto result = reflect(hit, &attacker, &target);
    check(result.canReflect && result.damage.primary.type == COMBAT_FIREDAMAGE,
          "secondary-only reflection must use the fire channel");
    check(result.damage.primary.value == -20, "must reflect secondary amount");
    check(result.damage.extension && result.params.aggressive,
          "reflection must retain recursion guard and aggressive flag");

    hit.primary.value = 0;
    result = reflect(hit, &attacker, &target);
    check(result.damage.primary.value == -20, "blocked primary must not erase reflection");

    Damage primaryReflection;
    primaryReflection.primary = {COMBAT_PHYSICALDAMAGE, -13};
    primaryReflection.extension = true;
    result = reflect(hit, &attacker, &target, primaryReflection, true);
    check(result.damage.primary.type == COMBAT_PHYSICALDAMAGE &&
          result.damage.primary.value == -13, "must preserve primary reflection");
    check(result.damage.secondary.type == COMBAT_FIREDAMAGE &&
          result.damage.secondary.value == -20, "must populate secondary reflection");

    target.flat = 7;
    result = reflect(hit, &attacker, &target);
    check(result.damage.primary.value == -27, "must retain flat reflection");
    attacker.maxHealth = 1000;
    result = reflect(hit, &attacker, &target);
    check(result.damage.primary.value == -10, "must retain secondary-only health cap");

    target.percent = 0;
    target.flat = 0;
    check(!reflect(hit, &attacker, &target).canReflect, "no reflect attributes");
    target.percent = 50;
    check(!reflect(hit, nullptr, &target).canReflect, "missing attacker");
    target.monster = false;
    check(!reflect(hit, &attacker, &target).canReflect, "non-monster target");
    target.monster = true;
    hit.extension = true;
    check(!reflect(hit, &attacker, &target).canReflect, "must not reflect reflection");
}
int main() {
    try {
        runChecks();
        return 0;
    } catch (const std::exception &error) {
        std::cerr << error.what() << '\n';
        return 1;
    }
}
"""


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", default="c++")
    parser.add_argument("--source", type=Path, default=Path("src/game/game.cpp"))
    args = parser.parse_args()
    block = reflection_block(args.source.read_text(encoding="utf-8"))
    with tempfile.TemporaryDirectory(prefix="canary-reflection-") as directory:
        source = Path(directory) / "reflection.cpp"
        executable = Path(directory) / "reflection.exe"
        source.write_text(PREAMBLE + block + CASES, encoding="utf-8")
        subprocess.run(
            [args.compiler, "-std=c++20", "-Wall", "-Wextra", "-Werror", str(source), "-o", str(executable)],
            check=True,
        )
        subprocess.run([str(executable)], check=True)
    print("Secondary reflection: production C++ block checks passed")


if __name__ == "__main__":
    main()
