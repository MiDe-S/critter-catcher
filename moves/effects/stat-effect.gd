extends Effect
class_name StatEffect

@export var multiplier := 1.0
@export var stat := statTypes.ATTACK
@export var duration: int

var critter: Critter

enum statTypes {
	ATTACK,
	DEFENSE,
	RANGE_ATTACK,
	RANGE_DEFENSE,
	SPEED,
	DAMAGE_REDUCTION
}

func incrementTurn() -> bool:
	if duration >= 0:
		duration -= 1
		if duration < 0:
			removeEffect()
			return false
	return true
	
func applyEffect(critterInput: Critter) -> void:
	critter = critterInput
	match stat:
		statTypes.ATTACK:
			critter.attackMultiplier *= multiplier
		statTypes.DEFENSE:
			critter.defenseMultiplier *= multiplier
		statTypes.RANGE_ATTACK:
			critter.rangeAttackMultiplier *= multiplier
		statTypes.RANGE_DEFENSE:
			critter.rangeDefenseMultiplier *= multiplier
		statTypes.SPEED:
			critter.speedMultiplier *= multiplier
		statTypes.DAMAGE_REDUCTION:
			critter.damageReduction *= multiplier
	
func removeEffect() -> void:
	match stat:
		statTypes.ATTACK:
			critter.attackMultiplier /= multiplier
		statTypes.DEFENSE:
			critter.defenseMultiplier /= multiplier
		statTypes.RANGE_ATTACK:
			critter.rangeAttackMultiplier /= multiplier
		statTypes.RANGE_DEFENSE:
			critter.rangeDefenseMultiplier /= multiplier
		statTypes.SPEED:
			critter.speedMultiplier /= multiplier
		statTypes.DAMAGE_REDUCTION:
			critter.damageReduction /= multiplier
