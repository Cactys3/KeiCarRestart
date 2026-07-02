extends Node
class_name ShopManager
## Weapon Scenes
const BOXING_GLOVES = "Boxing Gloves"
const PISTOL = "Pistol"
const SHOTGUN = "Shotgun"
const SHURIKEN = "Shuriken"
## Projectile Names
const BOXING_BLAST = "Boxing Blast"
const NINE_MM = "9mm"
## Blood Tree
const BLOOD_BORN = "Blood Born"
const BLOOD_MECHANIC = "Blood Mechanic"
const BLOOD_METER = "Blood Meter"
const BLOOD_RAGE = "Blood Rage"
const BLOOD_SPHERE = "Blood Sphere"
const BLOOD_TURRETS = "Blood Turrets"
const BLOODY_MAGAZINE = "Bloody Magazine"
const BLOODY_NEEDLES = "Bloody Needles"
const BLOODY_QUIVER = "Bloody Quiver"
const CRITICAL_BLEED = "Critical Bleed"
const CUTTING_STRIKES = "Cutting Strikes"
const GELID_HEOLFOR = "Gelid Heolfor"
const HEMOPLOSION = "Hemoplosion"
const PROLIFERATE = "Proliferate"
const SHARK = "Shark"
## Nerd Tree
const A_PLUS = "A+"
const ANIME = "Anime"
const BUILD_PLATE_XL = "BuildPlateXL"
const HOBBIES = "Hobbies"
const PRINTIN = "Printin"
const PROCRASTINATION = "Procrastination"
const SCISSOR_SWORD = "ScissorSword"
const SEASON_2 = "Season2"
const STACKING_STACKS = "StackingStacks"
## Ghost Tree
const FEAR = "Fear"
const FEARY = "Feary"
const GHOST_ARMY = "Ghost Army"
const GHOSTLY_HELPER = "Ghostly Helper"
const GHOSTSPLOSION = "Ghostsplosion"
const SPECTRE = "Spectre"
## Egg Tree
const EGG = "Egg"
const ENVIRONMENTAL_FACTORS = "EnvironmentalFactors"
const FRIENDS_AND_FAMILY = "FriendsAndFamily"
const HATCH = "Hatch"
const INCUBATE = "Incubate"
const NURTURE = "Nurture"
const TRADITIONS = "Traditions"
const TWINS = "Twins"
## Tank Tree
const AURA = "Aura"
const ELECTRIC_FENCE = "ElectricFence"
const HEALING_AURA = "HealingAura"
const INFINITE_SHIELD = "InfiniteShield"
const LANCE_PROTECTOR = "LanceProtector"
const MORE_HP = "MoreHP"
const MORE_HP_PLUS = "MoreHP+"
const OFFENSIVE_DEFENSE = "OffensiveDefense"
const QUICK_GETAWAY = "QuickGetaway"
const RUMP_ARMOR = "RumpArmor"
const SCALING_AURA = "ScalingAura"
const SHIELD = "Shield"
const SHIELD_PLUS = "Shield+"
const STATIKK_STRIKE = "StatikkStrike"
const STEEL_CREATIONS = "SteelCreations"
const STEEL_SKIN = "SteelSkin"
const STURDY = "Sturdy"
const STURDY_PLUS = "Sturdy+"
const VENGEFUL_AURA = "VengefulAura"
## Mage Tree
const AZARATH = "Azarath"
const BLUNT_MISSILE = "Blunt Missile"
const CASTER = "Caster"
const DARK_ORB_ = "Dark Orb+"
const DARK_ORB = "Dark Orb"
const DUPLICATION_SPELL = "Duplication Spell"
const FROST_MISSILE = "Frost Missile"
const LARGE_SPELL_NAME = "Large Spell Name"
const MAGIC_MISSILE = "Magic Missile"
const METRION = "Metrion"
const POISON_MISSILE = "Poison Missile"
const SHOCK_MISSILE = "Shock Missile"
const STONE_GNOMES = "Stone Gnomes"
const WET_MISSILE = "Wet Missile"
## Mechanic Tree
const COPY_CAT = "Copy Cat"
const CREATIONIST = "Creationist"
const DECOY = "Decoy"
const DEEP_COPY = "Deep Copy"
const FLAME_SPEWERS = "Flame Spewers"
const KAMI_KAMI = "Kami Kami"
const MECHA_BUFFED = "Mecha Buffed"
const MECHA_HEALER = "Mecha Healer"
## Ranger Tree
const ARROWS = "Arrows"
const BEAR_TRAP = "Bear Trap"
const BLEED_BEARS_BLEED = "Bleed Bears Bleed"
const BOSS_BANE = "Boss Bane"
const DUEL_WIELDING = "Duel Wielding"
const FLY_YOU_FOOLS = "Fly You Fools"
const GIGANITFY = "Giganitfy"
const TRAPPED_AND_MARKED = "Trapped And Marked"

## Weapon Scenes
const BOXING_GLOVES_SCENE = preload("uid://bbw0s4nlfy63s")
const PISTOL_SCENE = preload("uid://cjkad8i0d5u2g")
const SHOTGUN_SCENE = preload("uid://cjdtr6rhq2yso")
const SHURIKEN_SCENE = preload("uid://47u3dxb10h3n")
## Projectile Scenes 
const BOXING_BLAST_SCENE = preload("uid://d1gb0dt4hcvtx")
const NINE_MM_SCENE = preload("uid://c5n35stv668tp")
## Blood Tree
const BLOOD_BORN_SCENE = preload("uid://c6tfvrx3jikpg")
const BLOOD_MECHANIC_SCENE = preload("uid://bcfc0hdhceqpc")
const BLOOD_METER_SCENE = preload("uid://1xwwnlfmp6et")
const BLOOD_RAGE_SCENE = preload("uid://ug72dev0jq2d")
const BLOOD_SPHERE_SCENE = preload("uid://bwjdr1umu6h5k")
const BLOOD_TURRETS_SCENE = preload("uid://c5wosxw2gtbd5")
const BLOODY_MAGAZINE_SCENE = preload("uid://d1f0stejlye0n")
const BLOODY_NEEDLES_SCENE = preload("uid://jxh1upa5f50q")
const BLOODY_QUIVER_SCENE = preload("uid://br44c2vh2fhtf")
const CRITICAL_BLEED_SCENE = preload("uid://dj8tjwhyanqfg")
const CUTTING_STRIKES_SCENE = preload("uid://e4ho6vfqngai")
const GELID_HEOLFOR_SCENE = preload("uid://b3gs60rx8eg8u")
const HEMOPLOSION_SCENE = preload("uid://clsx2ugtfnojs")
const PROLIFERATE_SCENE = preload("uid://kers0tuck4se")
const SHARK_SCENE = preload("uid://swik15ufuq4a")
## Nerd Tree
const A_PLUS_SCENE = preload("uid://3ox6n5x2jdtb")
const ANIME_SCENE = preload("uid://bgyvl04jup1je")
const BUILD_PLATE_XL_SCENE = preload("uid://c4yvh1gs3ahmv")
const HOBBIES_SCENE = preload("uid://i67yvxkh1d8o")
const PRINTIN_SCENE = preload("uid://bq7siy68bu76r")
const PROCRASTINATION_SCENE = preload("uid://dx6wgy5svc6kc")
const SCISSOR_SWORD_SCENE = preload("uid://buhep55sdrfhg")
const SEASON_2_SCENE = preload("uid://ddcrdjhonahcv")
const STACKING_STACKS_SCENE = preload("uid://j60crhb84rib")
## Ghost Tree
const FEAR_SCENE = preload("uid://cwxpg0qrpjk8k")
const FEARY_SCENE = preload("uid://b3yf4m2mleant")
const GHOST_ARMY_SCENE = preload("uid://chg5xi3oq3nq7")
const GHOSTLY_HELPER_SCENE = preload("uid://b1njscxfupn3i")
const GHOSTSPLOSION_SCENE = preload("uid://6ltv35g54reg")
const SPECTRE_SCENE = preload("uid://cn4ef4p7088y1")
## Egg Tree
const EGG_SCENE = preload("uid://chvdaqkh4o2de")
const ENVIRONMENTAL_FACTORS_SCENE = preload("uid://n8ralq1lfxyw")
const FRIENDS_AND_FAMILY_SCENE = preload("uid://dqoemxqgx77lt")
const HATCH_SCENE = preload("uid://cjfyyts1i71rs")
const INCUBATE_SCENE = preload("uid://cy5dmdxdiet7v")
const NURTURE_SCENE = preload("uid://ceorhh4bama3n")
const TRADITIONS_SCENE = preload("uid://bbhxth6v3cwgh")
const TWINS_SCENE = preload("uid://dkpk2ao6erhco")
## Tank Tree
const AURA_SCENE  = preload("uid://pfahxp46qpaa")
const ELECTRIC_FENCE_SCENE  = preload("uid://mxfquarwvluu")
const HEALING_AURA_SCENE  = preload("uid://bu1lj2fh0t080")
const INFINITE_SHIELD_SCENE  = preload("uid://c67rj1yuvuubb")
const LANCE_PROTECTOR_SCENE  = preload("uid://cukbmdv7efshq")
const MORE_HP_PLUS_SCENE  = preload("uid://dbvwgetpm76ki")
const MORE_HP_SCENE  = preload("uid://bq2wq7kyfxpuo")
const OFFENSIVE_DEFENSE_SCENE  = preload("uid://b4mys831c8mu0")
const QUICK_GETAWAY_SCENE  = preload("uid://hmkcfxvy6pxv")
const RUMP_ARMOR_SCENE  = preload("uid://clg8kfxhaqe5j")
const SCALING_AURA_SCENE  = preload("uid://boiluwpic7kcj")
const SHIELD_PLUS_SCENE  = preload("uid://b24stvdr7j46r")
const SHIELD_SCENE  = preload("uid://bisroohu6t0lb")
const STATIKK_STRIKE_SCENE  = preload("uid://bx8r05v10jdha")
const STEEL_CREATIONS_SCENE  = preload("uid://fxomucugvo78")
const STEEL_SKIN_SCENE  = preload("uid://cc846iyo8ia3y")
const STURDY_PLUS_SCENE  = preload("uid://bay7xw8xgnvyk")
const STURDY_SCENE  = preload("uid://thp68b7naknu")
const VENGEFUL_AURA_SCENE  = preload("uid://bou8sdook2uh5")
## Mage Tree
const AZARATH_SCENE = preload("uid://cbhsbt4rgm3ds")
const BLUNT_MISSILE_SCENE = preload("uid://b04h5lg0pc86r")
const CASTER_SCENE = preload("uid://gh67t70mkjkb")
const DARK_ORB_SCENE_ = preload("uid://dcax4cwevpikv")
const DARK_ORB_SCENE = preload("uid://lx2ndf10nlo3")
const DUPLICATION_SPELL_SCENE = preload("uid://bkobmj3nxh2sj")
const FROST_MISSILE_SCENE = preload("uid://c724bder7iuxt")
const LARGE_SPELL_NAME_SCENE = preload("uid://dtipi3562y0vn")
const MAGIC_MISSILE_SCENE = preload("uid://crukgotdrboni")
const METRION_SCENE = preload("uid://bshdsl7ijfs0o")
const POISON_MISSILE_SCENE = preload("uid://bingxk7tcwrtf")
const SHOCK_MISSILE_SCENE = preload("uid://esppeaiu7rm1")
const STONE_GNOMES_SCENE = preload("uid://cfvrc8mx1505s")
const WET_MISSILE_SCENE = preload("uid://h73eqyff56ai")
## Mechanic Tree
const COPY_CAT_SCENE = preload("uid://bv0v8kcne1kpl")
const CREATIONIST_SCENE = preload("uid://cin83dvkk6wxj")
const DECOY_SCENE = preload("uid://ieoea6eepiit")
const DEEP_COPY_SCENE = preload("uid://ct7s3wnjsq5gg")
const FLAME_SPEWERS_SCENE = preload("uid://cxtb3irvno82o")
const KAMI_KAMI_SCENE = preload("uid://mlx10tww06ls")
const MECHA_BUFFED_SCENE = preload("uid://c3qwt077ej2kb")
const MECHA_HEALER_SCENE = preload("uid://b2qs0kvdfna4a")
## Ranger Tree
const ARROWS_SCENE = preload("uid://bwe0vbaruos8r")
const BEAR_TRAP_SCENE = preload("uid://g0v6sseax4ep")
const BLEED_BEARS_BLEED_SCENE = preload("uid://co83ia2bt1jc0")
const BOSS_BANE_SCENE = preload("uid://b87c1cbnx435j")
const DUEL_WIELDING_SCENE = preload("uid://bc6jpsvr353fh")
const FLY_YOU_FOOLS_SCENE = preload("uid://cgwqvxfx1b1ro")
const GIGANITFY_SCENE = preload("uid://djsypl1486fbs")
const TRAPPED_AND_MARKED_SCENE = preload("uid://cpw7ux7hbia5o")
## Arrays
static var unlocked_projectiles_keys: Array [String] = []
static var unlocked_weapon_keys: Array [String] = []
static var unlocked_upgrade_keys: Array [String] = []
## Upgrade Lists
const blood_tree: Dictionary [String, UpgradeData] = {
	BLOOD_BORN: BLOOD_BORN_SCENE,
	BLOOD_MECHANIC: BLOOD_MECHANIC_SCENE,
	BLOOD_METER: BLOOD_METER_SCENE,
	BLOOD_RAGE: BLOOD_RAGE_SCENE,
	BLOOD_SPHERE: BLOOD_SPHERE_SCENE,
	BLOODY_NEEDLES: BLOODY_NEEDLES_SCENE,
	BLOOD_TURRETS: BLOOD_TURRETS_SCENE,
	BLOODY_MAGAZINE: BLOODY_MAGAZINE_SCENE,
	BLOODY_QUIVER: BLOODY_QUIVER_SCENE,
	CRITICAL_BLEED: CRITICAL_BLEED_SCENE,
	CUTTING_STRIKES: CUTTING_STRIKES_SCENE,
	GELID_HEOLFOR: GELID_HEOLFOR_SCENE,
	HEMOPLOSION: HEMOPLOSION_SCENE,
	PROLIFERATE: PROLIFERATE_SCENE,
	SHARK: SHARK_SCENE}
const nerd_tree: Dictionary [String, UpgradeData] = {
	A_PLUS: A_PLUS_SCENE,
	ANIME: ANIME_SCENE,
	BUILD_PLATE_XL: BUILD_PLATE_XL_SCENE,
	HOBBIES: HOBBIES_SCENE,
	PRINTIN: PRINTIN_SCENE,
	PROCRASTINATION: PROCRASTINATION_SCENE,
	SCISSOR_SWORD: SCISSOR_SWORD_SCENE,
	SEASON_2: SEASON_2_SCENE,
	STACKING_STACKS: STACKING_STACKS_SCENE}

const upgrade_list: Dictionary [String, UpgradeData] = {
	BLOOD_BORN: BLOOD_BORN_SCENE,
	BLOOD_MECHANIC: BLOOD_MECHANIC_SCENE,
	BLOOD_METER: BLOOD_METER_SCENE,
	BLOOD_RAGE: BLOOD_RAGE_SCENE,
	BLOOD_SPHERE: BLOOD_SPHERE_SCENE,
	BLOODY_NEEDLES: BLOODY_NEEDLES_SCENE,
	BLOOD_TURRETS: BLOOD_TURRETS_SCENE,
	BLOODY_MAGAZINE: BLOODY_MAGAZINE_SCENE,
	BLOODY_QUIVER: BLOODY_QUIVER_SCENE,
	CRITICAL_BLEED: CRITICAL_BLEED_SCENE,
	CUTTING_STRIKES: CUTTING_STRIKES_SCENE,
	GELID_HEOLFOR: GELID_HEOLFOR_SCENE,
	HEMOPLOSION: HEMOPLOSION_SCENE,
	PROLIFERATE: PROLIFERATE_SCENE,
	SHARK: SHARK_SCENE,
	A_PLUS: A_PLUS_SCENE,
	ANIME: ANIME_SCENE,
	BUILD_PLATE_XL: BUILD_PLATE_XL_SCENE,
	HOBBIES: HOBBIES_SCENE,
	PRINTIN: PRINTIN_SCENE,
	PROCRASTINATION: PROCRASTINATION_SCENE,
	SCISSOR_SWORD: SCISSOR_SWORD_SCENE,
	SEASON_2: SEASON_2_SCENE,
	STACKING_STACKS: STACKING_STACKS_SCENE,
	FEAR: FEAR_SCENE,
	FEARY: FEARY_SCENE,
	GHOST_ARMY: GHOST_ARMY_SCENE,
	GHOSTLY_HELPER: GHOSTLY_HELPER_SCENE,
	GHOSTSPLOSION: GHOSTSPLOSION_SCENE,
	SPECTRE: SPECTRE_SCENE,
	EGG: EGG_SCENE,
	ENVIRONMENTAL_FACTORS: ENVIRONMENTAL_FACTORS_SCENE,
	FRIENDS_AND_FAMILY: FRIENDS_AND_FAMILY_SCENE,
	HATCH: HATCH_SCENE,
	INCUBATE: INCUBATE_SCENE,
	NURTURE: NURTURE_SCENE,
	TRADITIONS: TRADITIONS_SCENE,
	TWINS: TWINS_SCENE,
	#AURA: AURA_SCENE,
	#ELECTRIC_FENCE: ELECTRIC_FENCE_SCENE,
	#HEALING_AURA: HEALING_AURA_SCENE,
	#INFINITE_SHIELD: INFINITE_SHIELD_SCENE,
	#LANCE_PROTECTOR: LANCE_PROTECTOR_SCENE,
	#MORE_HP: MORE_HP_SCENE,
	#MORE_HP_PLUS: MORE_HP_PLUS_SCENE,
	#OFFENSIVE_DEFENSE: OFFENSIVE_DEFENSE_SCENE,
	#QUICK_GETAWAY: QUICK_GETAWAY_SCENE,
	#RUMP_ARMOR: RUMP_ARMOR_SCENE,
	#SCALING_AURA: SCALING_AURA_SCENE,
	#SHIELD: SHIELD_SCENE,
	#SHIELD_PLUS: SHIELD_PLUS_SCENE,
	#STATIKK_STRIKE: STATIKK_STRIKE_SCENE,
	#STEEL_CREATIONS: STEEL_CREATIONS_SCENE,
	#STEEL_SKIN: STEEL_SKIN_SCENE,
	#STURDY: STURDY_SCENE,
	#STURDY_PLUS: STURDY_PLUS_SCENE,
	#VENGEFUL_AURA: VENGEFUL_AURA_SCENE,
	#AZARATH: AZARATH_SCENE,
	#BLUNT_MISSILE: BLUNT_MISSILE_SCENE,
	#CASTER: CASTER_SCENE,
	#DARK_ORB_: DARK_ORB_SCENE_,
	#DARK_ORB: DARK_ORB_SCENE,
	#DUPLICATION_SPELL: DUPLICATION_SPELL_SCENE,
	#FROST_MISSILE: FROST_MISSILE_SCENE,
	#LARGE_SPELL_NAME: LARGE_SPELL_NAME_SCENE,
	#MAGIC_MISSILE: MAGIC_MISSILE_SCENE,
	#METRION: METRION_SCENE,
	#POISON_MISSILE: POISON_MISSILE_SCENE,
	#SHOCK_MISSILE: SHOCK_MISSILE_SCENE,
	#STONE_GNOMES: STONE_GNOMES_SCENE,
	#WET_MISSILE: WET_MISSILE_SCENE,
	#COPY_CAT: COPY_CAT_SCENE,
	#CREATIONIST: CREATIONIST_SCENE,
	#DECOY: DECOY_SCENE,
	#DEEP_COPY: DEEP_COPY_SCENE,
	#FLAME_SPEWERS: FLAME_SPEWERS_SCENE,
	#KAMI_KAMI: KAMI_KAMI_SCENE,
	#MECHA_BUFFED: MECHA_BUFFED_SCENE,
	#MECHA_HEALER: MECHA_HEALER_SCENE,
	#ARROWS: ARROWS_SCENE,
	#BEAR_TRAP: BEAR_TRAP_SCENE,
	#BLEED_BEARS_BLEED: BLEED_BEARS_BLEED_SCENE,
	#BOSS_BANE: BOSS_BANE_SCENE,
	#DUEL_WIELDING: DUEL_WIELDING_SCENE,
	#FLY_YOU_FOOLS: FLY_YOU_FOOLS_SCENE,
	#GIGANITFY: GIGANITFY_SCENE,
	#TRAPPED_AND_MARKED: TRAPPED_AND_MARKED_SCENE
	}
const weapon_list: Dictionary [String, PackedScene] = {
	BOXING_GLOVES: BOXING_GLOVES_SCENE,
	PISTOL: PISTOL_SCENE,
	SHOTGUN: SHOTGUN_SCENE,
	SHURIKEN: SHURIKEN_SCENE}
const projectile_list: Dictionary [String, PackedScene] = {
	BOXING_BLAST: BOXING_BLAST_SCENE,
	NINE_MM: NINE_MM_SCENE}

## Upgrade Indexes

## Returns Random Projectile
static func get_rand_projectile() -> Projectile:
	return projectile_list.get(get_random_unlocked_weapon_key()).instantiate()
## Returns Random Weapon
static func get_rand_weapon() -> Weapon:
		return weapon_list.get(get_random_unlocked_weapon_key()).instantiate()
## Returns Random, valid upgrade, will return empty array if no valid upgrade
static func get_rand_upgrades(count: int, game_man: GameManager) -> Array[UpgradeData]:
	var valid_upgrades: Array[UpgradeData] = get_all_valid_upgrades(game_man)
	var ret: Array[UpgradeData] = []
	## Pick At Random
	for e in count:
		if valid_upgrades.size() > 0:
			var upgrade: UpgradeData = valid_upgrades.pick_random()
			ret.append(upgrade)
			valid_upgrades.erase(upgrade)
	if ret.is_empty():
		printerr("Trying to get upgrade, but there are no valid upgrades")
	return ret
## Returns random projectile instance
static func get_projectile(key: String) -> Projectile:
	if projectile_list.has(key):
		return projectile_list.get(key).instantiate()
	printerr("Requesting non-existent projectile: ", key)
	return null
## Returns random weapon instance
static func get_weapon(key: String) -> Weapon:
	if weapon_list.has(key):
		return weapon_list.get(key).instantiate()
	printerr("Requesting non-existent weapon: ", key)
	return null
## 
static func get_upgrade(key: String) -> UpgradeData:
	if upgrade_list.has(key):
		return upgrade_list.get(key)
	printerr("Requesting non-existent upgrade: ", key)
	return null
## Returns random unlocked projectile's index
static func get_random_unlocked_projectile_key() -> String:
	return unlocked_weapon_keys.pick_random() #TODO: Check if attachment is unlocked?
static func get_random_unlocked_weapon_key() -> String:
	return unlocked_projectiles_keys.pick_random() #TODO: Check if attachment is unlocked?
#static func get_random_unlocked_upgrade_key() -> String:
	#return unlocked_upgrade_keys.pick_random() #TODO: Check if item is unlocked?
static func get_all_unlocked_weapons() -> Array[String]:
	return unlocked_weapon_keys
#static func get_all_unlocked_upgrades() -> Array[String]:
	#return unlocked_upgrade_keys
static func get_all_unlocked_projectiles() -> Array[String]:
	return unlocked_projectiles_keys
## Returns Random, valid upgrade, except those in avoided_items
static func get_rand_upgrades_except(avoided_items: Array[Upgrade], count: int, game_man: GameManager) -> Array[UpgradeData]:
	var valid_upgrades: Array[UpgradeData] = get_all_valid_upgrades(game_man)
	## Remove avoids
	for upgrade in avoided_items:
		if valid_upgrades.has(upgrade):
			valid_upgrades.erase(upgrade)
	## Pick At Random
	var ret: Array[UpgradeData] = []
	for e in count:
		if valid_upgrades.size() > 0:
			var upgrade: UpgradeData = valid_upgrades.pick_random()
			ret.append(upgrade)
			valid_upgrades.erase(upgrade)
	return ret
## Returns all upgrades that are valid to obtain and not already obtained
static func get_all_valid_upgrades(game_man: GameManager) -> Array[UpgradeData]:
	var array: Array[UpgradeData]
	for upgrade: UpgradeData in upgrade_list.values():
		## If we can obtain, add to list
		if upgrade.can_obtain(game_man.active_upgrades):
			array.append(upgrade)
	return array
