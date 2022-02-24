ScriptName ORomanceStatEditScript extends Quest

OSexIntegrationMain ostim
ORomanceScript oromance

actor playerref

int ORkey

Actor Property target
	Actor Function Get()
		return game.GetCurrentCrosshairRef() as actor
	EndFunction
EndProperty

Event OnInit()
	playerref = game.GetPlayer()
	ostim = OUtils.GetOStim()
	oromance = game.GetFormFromFile(0x000800, "ORomance.esp") as ORomanceScript
	
	Debug.Notification("ORomance Stat Editor installed")
	onload()
EndEvent

Function OnLoad()
	orkey = oromance.ORKey.GetValueInt()

	RegisterForKey(ORkey)

EndFunction


Event OnKeyDown(int KeyPress)
	If (outils.menuopen())
		Return
	EndIf
	
	if KeyPress == ORkey 
		if ostim.IsActorActive(playerref)
			return 
		endif 
		
		actor a = target

		Utility.Wait(2)

		if input.IsKeyPressed(KeyPress)
			if  a.IsInCombat() || outils.IsChild(a) || a.isdead() || !(a.GetRace().HasKeyword(Keyword.GetKeyword("ActorTypeNPC")))
				return 
			endif

			oromance.OUI.ExitDialogue(0)
			ShowStatMenu(a)
		endif
	endif
EndEvent



function ShowStatMenu(actor npc)
	oromance.OUI.ExitDialogue(0)

	ostim.PlayTickSmall()
	
	oromance.SeedIfNeeded(npc)
	debug.Notification("Editing: " + npc.GetDisplayName())

	UIListMenu listmenu = uiextensions.GetMenu("UIListMenu") as UIListMenu
	
	string[] options = new String[1]
	options[0] = "---- " + npc.GetDisplayName() + " ORomance Stats ----"

	options = PapyrusUtil.PushString(options, "Base difficulty: " + oromance.GetBaseValue(npc)) ; 1
	options = PapyrusUtil.PushString(options, "Custom difficulty mod: " + oromance.GetCustomValue(npc)) ; 2

	options = PapyrusUtil.PushString(options, "Sex desire: " + oromance.getSexDesireStat(npc) + " / 100") ; 3
	options = PapyrusUtil.PushString(options, "Prudishness: " + oromance.getPrudishnessStat(npc) + " / 100") ; 4
	options = PapyrusUtil.PushString(options, "Monogamy desire: " + oromance.getMonogamyDesireStat(npc) + " / 100") ; 5

	options = PapyrusUtil.PushString(options, "Player love: " + oromance.getloveStat(npc) + " / 30") ; 6
	options = PapyrusUtil.PushString(options, "Player like: " + oromance.getlikeStat(npc) + " / 30") ; 7
	options = PapyrusUtil.PushString(options, "Player dislike: " + oromance.getdislikeStat(npc) + " / 30") ; 8
	options = PapyrusUtil.PushString(options, "Player hate: " + oromance.gethateStat(npc) + " / 30") ; 9

	options = PapyrusUtil.PushString(options, "Sexuality: " + oromance.GetSexuality(npc)) ; 10

	options = PapyrusUtil.PushString(options, "Is player gf/bf: " + oromance.IsPlayerPartner(npc) as int) ; 11
	
	options = PapyrusUtil.PushString(options, "Prostitution price: " + oromance.getPrositutionCost(npc)) ; 12

	options = PapyrusUtil.PushString(options, "Is virgin: " + oromance.IsVirgin(npc) as int) ; 13

	options = PapyrusUtil.PushString(options, "Is player spouse: " + oromance.IsPlayerSpouse(npc) as int) ; 14

	options = PapyrusUtil.PushString(options, "Is prostitute: " + oromance.IsProstitute(npc) as int) ; 15

	;--- cannot edit
	;options = PapyrusUtil.PushString(options, "--- non-editable options ---"); 13

	
	
	


	int i = 0
	int max = options.length
	while (i < max)
		listmenu.AddEntryItem( options[i])

		i += 1
	endwhile
	listmenu.OpenMenu(npc)



	int result = options.find(listmenu.GetResultString())
	;console(result)

	if result < 1 
		oromance.OUI.ExitDialogue(0)
		return 
	endif

	int playerinput = GetIntFromPlayer()

	if playerinput == -600
		oromance.OUI.ExitDialogue(0)
		return 
	endif 

	if result == 1 
		outils.StoreNPCDataInt(npc, BaseStatKey, playerinput)
	elseif result == 2
		outils.StoreNPCDataInt(npc, CustomStatKey, playerinput)
	elseif result == 3
		OUtils.StoreNPCDataInt(npc, SexDesireKey, playerinput)
	elseif result == 4
		OUtils.StoreNPCDataInt(npc, PrudishnessKey, playerinput)
	elseif result == 5
		OUtils.StoreNPCDataInt(npc, MonogamyDesireKey, playerinput)
	elseif result == 6
		OUtils.StoreNPCDataFloat(npc, lovekey, playerinput)
	elseif result == 7
		OUtils.StoreNPCDataFloat(npc, likekey, playerinput)
	elseif result == 8
		OUtils.StoreNPCDataFloat(npc, dislikekey, playerinput)
	elseif result == 9
		OUtils.StoreNPCDataFloat(npc, hateKey, playerinput)
	elseif result == 10
		OUtils.storenpcdataint(npc, SexualityKey, playerinput)
	elseif result == 11
		OUtils.StoreNPCDataBool(npc, IsPlayerPartnerKey, playerinput as bool)
	elseif result == 12
		OUtils.StoreNPCDataInt(npc, ProstitutionCostKey, playerinput)
	elseif result == 13
		OUtils.StoreNPCDataInt(npc, IsVirginKey, playerinput)
	elseif result == 14
		if playerinput == 1 
			oromance.PlayerLoveInterest.ForceRefTo(npc)
		else 
			oromance.PlayerLoveInterest.Clear()
		endif
	elseif result == 15
		
		if playerinput == 1 
			npc.addtofaction(game.GetFormFromFile(0x0DEE93, "Skyrim.esm") as faction)
		else 
			npc.RemoveFromFaction(game.GetFormFromFile(0x0DEE93, "Skyrim.esm") as faction)
			npc.RemoveFromFaction(game.GetFormFromFile(0x060028, "Skyrim.esm") as faction)
			npc.RemoveFromFaction(game.GetFormFromFile(0x0656EA, "Skyrim.esm") as faction)
		endif


	endif 

	ShowStatMenu(npc)
EndFunction



int Function GetIntFromPlayer()
	ostim.PlayTickSmall()
	debug.Notification("Enter a number value")
	uimenubase searchbar = uiextensions.GetMenu("UITextEntryMenu")
	searchbar.OpenMenu()

	string str = searchbar.GetResultString()
	int ret = str as int

	if str == ""
		ret = -600
	endif 

	return ret
EndFunction



	string SexDesireKey = "or_k_sexdesire"
	string PrudishnessKey = "or_k_prudishness"
	string MonogamyDesireKey = "or_k_monogamy"
	string isSeededKey = "or_k_seeded"

	string loveKey = "or_k_love"
	string likeKey = "or_k_li"
	string dislikeKey = "or_k_di"
	string hateKey = "or_k_hate"

	string LikeLastAccessKey = "or_k_li_last"
	string DisLikeLastAccessKey = "or_k_di_last"

	string LastSeduceTimeKey = "or_k_last_seduce"
	string LastKissTimeKey = "or_k_last_kiss"

	string BaseStatKey = "or_k_base"
	string CustomStatKey = "or_k_customSV"

	string IsPlayerPartnerKey = "or_k_part"

	string ProstitutionCostKey = "or_k_cost"

	string sexualitykey = "or_k_sexu"

	string IsVirginKey = "IsVirgin"