tempDataStorage = {}
Config = {}
Config["base_key"] = 19
Config['Global_TimeOut'] = 2000; -- ระยะเวลากล่องแจ้งเตือนโดยรวม
Config["duration"] = 7 -- ระยะเวลาที่จะตอบรับ
Config["red_radius"] = 60.0 -- ขนาดของวงที่จะขึ้นบนแมพ เมื่อมีการแจ้งเตือน
Config["Color"] = 
{
	police = '#151888',
	ambulance = '#ff8ff8'
}

Config["alert_section"] = {
	carjacking = false,
	melee = false,
	gunshot = false,
	drug = true,
	fishing = true,
	burglary = true,
	thief = true,
	cement = true,
	cable = true,
}

Config.playsound = true

Config["translate"] = {
	title = "",
	male = "เพศ ชาย",
	female = "เพศ หญิง",
	text = "",
	tip = "<btn>เพื่อรับงานนี้</btn>",
	action_carjacking = 'ขโมยรถ',
	action_melee = 'ทำร้ายร่างกาย',
	action_gunshot = 'ยิงปืนไม่ทราบชนิด',
	action_fishing = 'ตกปลาผิดกฏหมาย',
	action_burglary = 'บุกรุก',
	action_drug = 'ค้ายา',
	action_thief = 'โจรกรรม',
	action_cement = '<btn class="btn btn-warning">ขโมยปูน</btn>',
	action_cable = 'ขโมยสายไฟ',
	action_tumra = 'ขโมยแคป',
	action_bodybag = 'มีคนโดนห่อ',
	action_dead = 'มีคนอาการโคม่าาา',
	action_coma = 'มีคนอาการโคม่า อาจถึงตาย',
}

