deserialize ("Layer",
{
	{--Entry Number: {1}
		["visible"]="true",
		["type"]="LayerDD",
		["name"]="gameHud.lua",
		["propContainer"]={2},
		["scripts"]={3},
		["position"]={4},
	},

	{--Entry Number: {2}
		[1]={5},
    [2]={10},
    [3]={25},
    [4]={30},
    [5]={35}, --pause, uncomment back for First Playable!!!!!!!!!!
    --[3]={15},
    --[4]={20},
	},

	{--Entry Number: {3}
		[1]="Hud.lua",
	},

	{--Entry Number: {4}
		["y"]=0,
		["x"]=0,
		["z"]=0,
	},

	{--Entry Number: {5}
		["type"]="TextBox",
		["scale"]={6},
		["shaderName"]="none",
		["rectangle"]={7},
		["name"]="TextBox#1",
		["position"]={8},
		["scripts"]={9},
		["textSize"]=48,
    ["justification"]="center_justify",
		["string"]="Time",
	},

	{--Entry Number: {6}
		["y"]=1,
		["x"]=1,
		["z"]=1,
	},

	{--Entry Number: {7}
		["x2"]=300,
		["y2"]=100,
		["y1"]=0,
		["x1"]=-300,
	},

	{--Entry Number: {8}
		["y"]=250,
		["x"]=0,
		["z"]=0,
	},

	{--Entry Number: {9}
		[1]="gameTimer.lua",
	},
  
  {--Entry Number: {10}
		["type"]="TextBox",
		["scale"]={11},
		["shaderName"]="none",
		["rectangle"]={12},
		["name"]="TextBox#2",
		["position"]={13},
		["scripts"]={14},
		["textSize"]=24,
    ["justification"]="left_justify",
		["string"]="Score",
	},

	{--Entry Number: {11}
		["y"]=1,
		["x"]=1,
		["z"]=1,
	},

	{--Entry Number: {12}
		["x2"]=300,
		["y2"]=100,
		["y1"]=0,
		["x1"]=0,
	},

	{--Entry Number: {13}
		["y"]=225,
		["x"]=400,
		["z"]=0,
	},

	{--Entry Number: {14}
		[1]="gameScore.lua",
	},
  
  {--Entry Number: {15}
		["type"]="TextBox",
		["scale"]={16},
		["shaderName"]="none",
		["rectangle"]={17},
		["name"]="TextBox#3",
		["position"]={18},
		["scripts"]={19},
		["textSize"]=24,
		["string"]="Distance: ",
	},

	{--Entry Number: {16}
		["y"]=1,
		["x"]=1,
		["z"]=1,
	},

	{--Entry Number: {17}
		["x2"]=300,
		["y2"]=100,
		["y1"]=0,
		["x1"]=0,
	},

	{--Entry Number: {18}
		["y"]=225,
		["x"]=600,
		["z"]=0,
	},

	{--Entry Number: {19}
		[1]="gameDistance.lua",
	},
  
  {--Entry Number: {20}
		["type"]="TextBox",
		["scale"]={21},
		["shaderName"]="none",
		["rectangle"]={22},
		["name"]="TextBox#4",
		["position"]={23},
		["scripts"]={24},
		["textSize"]=24,
		["string"]="Rings: ",
	},

	{--Entry Number: {21}
		["y"]=1,
		["x"]=1,
		["z"]=1,
	},

	{--Entry Number: {22}
		["x2"]=300,
		["y2"]=100,
		["y1"]=0,
		["x1"]=-300,
	},

	{--Entry Number: {23}
		["y"]=200,
		["x"]=400,
		["z"]=0,
	},

	{--Entry Number: {24}
		[1]="gameRings.lua",
	},
  
  {--Entry Number: {25}
		["type"]="TextBox",
		["scale"]={26},
		["shaderName"]="none",
		["rectangle"]={27},
		["name"]="TextBox#4",
		["position"]={28},
		["scripts"]={29},
		["textSize"]=24,
    ["justification"]="left_justify",
		["string"]="High Score:",
	},

	{--Entry Number: {26}
		["y"]=1,
		["x"]=1,
		["z"]=1,
	},

	{--Entry Number: {27}
		["x2"]=300,
		["y2"]=100,
		["y1"]=0,
		["x1"]=0,
	},

	{--Entry Number: {28}
		["y"]=250,
		["x"]=400,
		["z"]=0,
	},

	{--Entry Number: {29}
		[1]="gameHScore.lua",
	},
  
  {--Entry Number: {30}
		["rotation"]={31},
		["type"]="Prop",
		["name"]="refresh",
		["scripts"]={32},
		["scale"]={33},
		["shaderName"]="basic2d",
		["position"]={34},
		["textureName"]="refresh.png",
	},
  
  	{--Entry Number: {31}
		["y"]=0,
		["x"]=0,
		["z"]=0,
	},

	{--Entry Number: {32}		
	},

	{--Entry Number: {33}
		["y"]=.5,
		["x"]=.5,
		["z"]=1,
	},

  {--Entry Number: {34}
    ["y"]=325,
		["x"]=-600,
		["z"]=0,
  },
  
  {--Entry Number: {35}
		["rotation"]={36},
		["type"]="Prop",
		["name"]="refresh",
		["scripts"]={37},
		["scale"]={38},
		["shaderName"]="basic2d",
		["position"]={39},
		["textureName"]="pause.png",
	},
  
  	{--Entry Number: {36}
		["y"]=0,
		["x"]=0,
		["z"]=0,
	},

	{--Entry Number: {37}	
		"pauseButtonUpdate.lua",	
	},

	{--Entry Number: {38}
		["y"]=.5,
		["x"]=.5,
		["z"]=1,
	},

  {--Entry Number: {39}
    ["y"]=-325,
		["x"]=550,
		["z"]=0,
  },
})

