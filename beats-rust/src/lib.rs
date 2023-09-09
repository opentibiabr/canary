use std::f64;

#[no_mangle]
pub extern "C" fn get_base_attack(level: u32) -> i32 {
    let square = f64::sqrt(2.0 * (level as f64) - 1.0 + 2025.0);
    let step_formula = f64::floor((square + 5.0) / 10.0);
    let frac = ((level as f64 + 1000.0) / step_formula) - (50.0 * step_formula);
    let base_form = frac + (100.0 * step_formula) - 450.0;

    base_form.floor() as i32
}

#[no_mangle]
pub extern "C" fn get_max_weapon_damage(attack_skill: i32, attack_value: i32, attack_factor: f32, attack_value_base: i32, is_melee: bool) -> i32 {
    // Implementação da função
    if is_melee {
        return (attack_value_base as f32 + ((attack_factor * attack_value as f32) * (attack_skill as f32 + 4.0) / 28.0)) as i32;
    }

    return ((0.09 * attack_factor * attack_skill as f32 * attack_value as f32) + attack_value_base as f32).round() as i32;
}

#[cfg(test)]
// use: cargo test -- --nocapture / cargo test --package beats --lib -- --nocapture / cargo test --package beats --lib "nome_do_teste_exato" -- --nocapture
mod tests {
    use super::*;

    #[test]
    fn get_attack_base() {
        let result = get_base_attack(1100);
        println!("O valor de get_attack_base é: {}", result);
        assert_eq!(result, 200);
    }

    #[test]
    fn test_get_max_weapon_damage_melee() {
        let damage = get_max_weapon_damage(10, 50, 1.0, 100, true);
        println!("O valor de test_get_max_weapon_damage_melee é: {}", damage);
        assert_eq!(damage, 125); // Valor exemplo
    }

    #[test]
    fn test_get_max_weapon_damage_ranged() {
        let damage = get_max_weapon_damage(10, 50, 1.0, 100, false);
        println!("O valor de test_get_max_weapon_damage_ranged é: {}", damage);
        assert_eq!(damage, 145); // Valor exemplo
    }
}
