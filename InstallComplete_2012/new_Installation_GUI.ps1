# ====================================================================================================
# 
# NAME: installation.ps1
# 
# AUTHOR: Holger Voges
# DATE  : 08.04.2011 : Initial Release
# 
# COMMENT: 	GUI for Create_ini.ps1. Erzeugt die aufzurufenden Paramter für die unbeaufsichtigte 
#			Installation aus einer GUI.
#
# Changes:  27.06.2012
#           - Changed FMO-Port to 30000+
#			11.07.2012
#			- added SQL-Server 2012 Values
#			- changed Default-Start mode to without FMO
#			24.07.2012
#			- updated GUI to support Service-Kids for AS and RS
#			- added configuration-File support. Config-Files will be chosen automatically by the domain-name
#			  added to the config-File but can be changed in the GUI
#			18.10.2012
#			- updated script that it recognizes missing AD-modul and skips password-checking if so
#
# =====================================================================================================

#region Self defined Functions

function Main
{
	$compDom = (Get-WmiObject -Namespace root\CIMV2 -Class Win32_ComputerSystem | % {$_.domain})
	$Dom = $compDom.Substring(0,$compDom.IndexOf("."))
	$configFile = "Configuration_$dom.xml"
	$col2005 = "Albanian_BIN","Albanian_BIN2","Albanian_CI_AI","Albanian_CI_AI_WS","Albanian_CI_AI_KS","Albanian_CI_AI_KS_WS","Albanian_CI_AS","Albanian_CI_AS_WS","Albanian_CI_AS_KS","Albanian_CI_AS_KS_WS","Albanian_CS_AI","Albanian_CS_AI_WS","Albanian_CS_AI_KS","Albanian_CS_AI_KS_WS","Albanian_CS_AS","Albanian_CS_AS_WS","Albanian_CS_AS_KS","Albanian_CS_AS_KS_WS","Arabic_BIN","Arabic_BIN2","Arabic_CI_AI","Arabic_CI_AI_WS","Arabic_CI_AI_KS","Arabic_CI_AI_KS_WS","Arabic_CI_AS","Arabic_CI_AS_WS","Arabic_CI_AS_KS","Arabic_CI_AS_KS_WS","Arabic_CS_AI","Arabic_CS_AI_WS","Arabic_CS_AI_KS","Arabic_CS_AI_KS_WS","Arabic_CS_AS","Arabic_CS_AS_WS","Arabic_CS_AS_KS","Arabic_CS_AS_KS_WS","Azeri_Cyrillic_90_BIN","Azeri_Cyrillic_90_BIN2","Azeri_Cyrillic_90_CI_AI","Azeri_Cyrillic_90_CI_AI_WS","Azeri_Cyrillic_90_CI_AI_KS","Azeri_Cyrillic_90_CI_AI_KS_WS","Azeri_Cyrillic_90_CI_AS","Azeri_Cyrillic_90_CI_AS_WS","Azeri_Cyrillic_90_CI_AS_KS","Azeri_Cyrillic_90_CI_AS_KS_WS","Azeri_Cyrillic_90_CS_AI","Azeri_Cyrillic_90_CS_AI_WS","Azeri_Cyrillic_90_CS_AI_KS","Azeri_Cyrillic_90_CS_AI_KS_WS","Azeri_Cyrillic_90_CS_AS","Azeri_Cyrillic_90_CS_AS_WS","Azeri_Cyrillic_90_CS_AS_KS","Azeri_Cyrillic_90_CS_AS_KS_WS","Azeri_Latin_90_BIN","Azeri_Latin_90_BIN2","Azeri_Latin_90_CI_AI","Azeri_Latin_90_CI_AI_WS","Azeri_Latin_90_CI_AI_KS","Azeri_Latin_90_CI_AI_KS_WS","Azeri_Latin_90_CI_AS","Azeri_Latin_90_CI_AS_WS","Azeri_Latin_90_CI_AS_KS","Azeri_Latin_90_CI_AS_KS_WS","Azeri_Latin_90_CS_AI","Azeri_Latin_90_CS_AI_WS","Azeri_Latin_90_CS_AI_KS","Azeri_Latin_90_CS_AI_KS_WS","Azeri_Latin_90_CS_AS","Azeri_Latin_90_CS_AS_WS","Azeri_Latin_90_CS_AS_KS","Azeri_Latin_90_CS_AS_KS_WS","Chinese_Hong_Kong_Stroke_90_BIN","Chinese_Hong_Kong_Stroke_90_BIN2","Chinese_Hong_Kong_Stroke_90_CI_AI","Chinese_Hong_Kong_Stroke_90_CI_AI_WS","Chinese_Hong_Kong_Stroke_90_CI_AI_KS","Chinese_Hong_Kong_Stroke_90_CI_AI_KS_WS","Chinese_Hong_Kong_Stroke_90_CI_AS","Chinese_Hong_Kong_Stroke_90_CI_AS_WS","Chinese_Hong_Kong_Stroke_90_CI_AS_KS","Chinese_Hong_Kong_Stroke_90_CI_AS_KS_WS","Chinese_Hong_Kong_Stroke_90_CS_AI","Chinese_Hong_Kong_Stroke_90_CS_AI_WS","Chinese_Hong_Kong_Stroke_90_CS_AI_KS","Chinese_Hong_Kong_Stroke_90_CS_AI_KS_WS","Chinese_Hong_Kong_Stroke_90_CS_AS","Chinese_Hong_Kong_Stroke_90_CS_AS_WS","Chinese_Hong_Kong_Stroke_90_CS_AS_KS","Chinese_Hong_Kong_Stroke_90_CS_AS_KS_WS","Chinese_PRC_BIN","Chinese_PRC_BIN2","Chinese_PRC_CI_AI","Chinese_PRC_CI_AI_WS","Chinese_PRC_CI_AI_KS","Chinese_PRC_CI_AI_KS_WS","Chinese_PRC_CI_AS","Chinese_PRC_CI_AS_WS","Chinese_PRC_CI_AS_KS","Chinese_PRC_CI_AS_KS_WS","Chinese_PRC_CS_AI","Chinese_PRC_CS_AI_WS","Chinese_PRC_CS_AI_KS","Chinese_PRC_CS_AI_KS_WS","Chinese_PRC_CS_AS","Chinese_PRC_CS_AS_WS","Chinese_PRC_CS_AS_KS","Chinese_PRC_CS_AS_KS_WS","Chinese_PRC_90_BIN","Chinese_PRC_90_BIN2","Chinese_PRC_90_CI_AI","Chinese_PRC_90_CI_AI_WS","Chinese_PRC_90_CI_AI_KS","Chinese_PRC_90_CI_AI_KS_WS","Chinese_PRC_90_CI_AS","Chinese_PRC_90_CI_AS_WS","Chinese_PRC_90_CI_AS_KS","Chinese_PRC_90_CI_AS_KS_WS","Chinese_PRC_90_CS_AI","Chinese_PRC_90_CS_AI_WS","Chinese_PRC_90_CS_AI_KS","Chinese_PRC_90_CS_AI_KS_WS","Chinese_PRC_90_CS_AS","Chinese_PRC_90_CS_AS_WS","Chinese_PRC_90_CS_AS_KS","Chinese_PRC_90_CS_AS_KS_WS","Chinese_PRC_Stroke_BIN","Chinese_PRC_Stroke_BIN2","Chinese_PRC_Stroke_CI_AI","Chinese_PRC_Stroke_CI_AI_WS","Chinese_PRC_Stroke_CI_AI_KS","Chinese_PRC_Stroke_CI_AI_KS_WS","Chinese_PRC_Stroke_CI_AS","Chinese_PRC_Stroke_CI_AS_WS","Chinese_PRC_Stroke_CI_AS_KS","Chinese_PRC_Stroke_CI_AS_KS_WS","Chinese_PRC_Stroke_CS_AI","Chinese_PRC_Stroke_CS_AI_WS","Chinese_PRC_Stroke_CS_AI_KS","Chinese_PRC_Stroke_CS_AI_KS_WS","Chinese_PRC_Stroke_CS_AS","Chinese_PRC_Stroke_CS_AS_WS","Chinese_PRC_Stroke_CS_AS_KS","Chinese_PRC_Stroke_CS_AS_KS_WS","Chinese_PRC_Stroke_90_BIN","Chinese_PRC_Stroke_90_BIN2","Chinese_PRC_Stroke_90_CI_AI","Chinese_PRC_Stroke_90_CI_AI_WS","Chinese_PRC_Stroke_90_CI_AI_KS","Chinese_PRC_Stroke_90_CI_AI_KS_WS","Chinese_PRC_Stroke_90_CI_AS","Chinese_PRC_Stroke_90_CI_AS_WS","Chinese_PRC_Stroke_90_CI_AS_KS","Chinese_PRC_Stroke_90_CI_AS_KS_WS","Chinese_PRC_Stroke_90_CS_AI","Chinese_PRC_Stroke_90_CS_AI_WS","Chinese_PRC_Stroke_90_CS_AI_KS","Chinese_PRC_Stroke_90_CS_AI_KS_WS","Chinese_PRC_Stroke_90_CS_AS","Chinese_PRC_Stroke_90_CS_AS_WS","Chinese_PRC_Stroke_90_CS_AS_KS","Chinese_PRC_Stroke_90_CS_AS_KS_WS","Chinese_Taiwan_Bopomofo_BIN","Chinese_Taiwan_Bopomofo_BIN2","Chinese_Taiwan_Bopomofo_CI_AI","Chinese_Taiwan_Bopomofo_CI_AI_WS","Chinese_Taiwan_Bopomofo_CI_AI_KS","Chinese_Taiwan_Bopomofo_CI_AI_KS_WS","Chinese_Taiwan_Bopomofo_CI_AS","Chinese_Taiwan_Bopomofo_CI_AS_WS","Chinese_Taiwan_Bopomofo_CI_AS_KS","Chinese_Taiwan_Bopomofo_CI_AS_KS_WS","Chinese_Taiwan_Bopomofo_CS_AI","Chinese_Taiwan_Bopomofo_CS_AI_WS","Chinese_Taiwan_Bopomofo_CS_AI_KS","Chinese_Taiwan_Bopomofo_CS_AI_KS_WS","Chinese_Taiwan_Bopomofo_CS_AS","Chinese_Taiwan_Bopomofo_CS_AS_WS","Chinese_Taiwan_Bopomofo_CS_AS_KS","Chinese_Taiwan_Bopomofo_CS_AS_KS_WS","Chinese_Taiwan_Bopomofo_90_BIN","Chinese_Taiwan_Bopomofo_90_BIN2","Chinese_Taiwan_Bopomofo_90_CI_AI","Chinese_Taiwan_Bopomofo_90_CI_AI_WS","Chinese_Taiwan_Bopomofo_90_CI_AI_KS","Chinese_Taiwan_Bopomofo_90_CI_AI_KS_WS","Chinese_Taiwan_Bopomofo_90_CI_AS","Chinese_Taiwan_Bopomofo_90_CI_AS_WS","Chinese_Taiwan_Bopomofo_90_CI_AS_KS","Chinese_Taiwan_Bopomofo_90_CI_AS_KS_WS","Chinese_Taiwan_Bopomofo_90_CS_AI","Chinese_Taiwan_Bopomofo_90_CS_AI_WS","Chinese_Taiwan_Bopomofo_90_CS_AI_KS","Chinese_Taiwan_Bopomofo_90_CS_AI_KS_WS","Chinese_Taiwan_Bopomofo_90_CS_AS","Chinese_Taiwan_Bopomofo_90_CS_AS_WS","Chinese_Taiwan_Bopomofo_90_CS_AS_KS","Chinese_Taiwan_Bopomofo_90_CS_AS_KS_WS","Chinese_Taiwan_Stroke_BIN","Chinese_Taiwan_Stroke_BIN2","Chinese_Taiwan_Stroke_CI_AI","Chinese_Taiwan_Stroke_CI_AI_WS","Chinese_Taiwan_Stroke_CI_AI_KS","Chinese_Taiwan_Stroke_CI_AI_KS_WS","Chinese_Taiwan_Stroke_CI_AS","Chinese_Taiwan_Stroke_CI_AS_WS","Chinese_Taiwan_Stroke_CI_AS_KS","Chinese_Taiwan_Stroke_CI_AS_KS_WS","Chinese_Taiwan_Stroke_CS_AI","Chinese_Taiwan_Stroke_CS_AI_WS","Chinese_Taiwan_Stroke_CS_AI_KS","Chinese_Taiwan_Stroke_CS_AI_KS_WS","Chinese_Taiwan_Stroke_CS_AS","Chinese_Taiwan_Stroke_CS_AS_WS","Chinese_Taiwan_Stroke_CS_AS_KS","Chinese_Taiwan_Stroke_CS_AS_KS_WS","Chinese_Taiwan_Stroke_90_BIN","Chinese_Taiwan_Stroke_90_BIN2","Chinese_Taiwan_Stroke_90_CI_AI","Chinese_Taiwan_Stroke_90_CI_AI_WS","Chinese_Taiwan_Stroke_90_CI_AI_KS","Chinese_Taiwan_Stroke_90_CI_AI_KS_WS","Chinese_Taiwan_Stroke_90_CI_AS","Chinese_Taiwan_Stroke_90_CI_AS_WS","Chinese_Taiwan_Stroke_90_CI_AS_KS","Chinese_Taiwan_Stroke_90_CI_AS_KS_WS","Chinese_Taiwan_Stroke_90_CS_AI","Chinese_Taiwan_Stroke_90_CS_AI_WS","Chinese_Taiwan_Stroke_90_CS_AI_KS","Chinese_Taiwan_Stroke_90_CS_AI_KS_WS","Chinese_Taiwan_Stroke_90_CS_AS","Chinese_Taiwan_Stroke_90_CS_AS_WS","Chinese_Taiwan_Stroke_90_CS_AS_KS","Chinese_Taiwan_Stroke_90_CS_AS_KS_WS","Croatian_BIN","Croatian_BIN2","Croatian_CI_AI","Croatian_CI_AI_WS","Croatian_CI_AI_KS","Croatian_CI_AI_KS_WS","Croatian_CI_AS","Croatian_CI_AS_WS","Croatian_CI_AS_KS","Croatian_CI_AS_KS_WS","Croatian_CS_AI","Croatian_CS_AI_WS","Croatian_CS_AI_KS","Croatian_CS_AI_KS_WS","Croatian_CS_AS","Croatian_CS_AS_WS","Croatian_CS_AS_KS","Croatian_CS_AS_KS_WS","Cyrillic_General_BIN","Cyrillic_General_BIN2","Cyrillic_General_CI_AI","Cyrillic_General_CI_AI_WS","Cyrillic_General_CI_AI_KS","Cyrillic_General_CI_AI_KS_WS","Cyrillic_General_CI_AS","Cyrillic_General_CI_AS_WS","Cyrillic_General_CI_AS_KS","Cyrillic_General_CI_AS_KS_WS","Cyrillic_General_CS_AI","Cyrillic_General_CS_AI_WS","Cyrillic_General_CS_AI_KS","Cyrillic_General_CS_AI_KS_WS","Cyrillic_General_CS_AS","Cyrillic_General_CS_AS_WS","Cyrillic_General_CS_AS_KS","Cyrillic_General_CS_AS_KS_WS","Czech_BIN","Czech_BIN2","Czech_CI_AI","Czech_CI_AI_WS","Czech_CI_AI_KS","Czech_CI_AI_KS_WS","Czech_CI_AS","Czech_CI_AS_WS","Czech_CI_AS_KS","Czech_CI_AS_KS_WS","Czech_CS_AI","Czech_CS_AI_WS","Czech_CS_AI_KS","Czech_CS_AI_KS_WS","Czech_CS_AS","Czech_CS_AS_WS","Czech_CS_AS_KS","Czech_CS_AS_KS_WS","Danish_Norwegian_BIN","Danish_Norwegian_BIN2","Danish_Norwegian_CI_AI","Danish_Norwegian_CI_AI_WS","Danish_Norwegian_CI_AI_KS","Danish_Norwegian_CI_AI_KS_WS","Danish_Norwegian_CI_AS","Danish_Norwegian_CI_AS_WS","Danish_Norwegian_CI_AS_KS","Danish_Norwegian_CI_AS_KS_WS","Danish_Norwegian_CS_AI","Danish_Norwegian_CS_AI_WS","Danish_Norwegian_CS_AI_KS","Danish_Norwegian_CS_AI_KS_WS","Danish_Norwegian_CS_AS","Danish_Norwegian_CS_AS_WS","Danish_Norwegian_CS_AS_KS","Danish_Norwegian_CS_AS_KS_WS","Divehi_90_BIN","Divehi_90_BIN2","Divehi_90_CI_AI","Divehi_90_CI_AI_WS","Divehi_90_CI_AI_KS","Divehi_90_CI_AI_KS_WS","Divehi_90_CI_AS","Divehi_90_CI_AS_WS","Divehi_90_CI_AS_KS","Divehi_90_CI_AS_KS_WS","Divehi_90_CS_AI","Divehi_90_CS_AI_WS","Divehi_90_CS_AI_KS","Divehi_90_CS_AI_KS_WS","Divehi_90_CS_AS","Divehi_90_CS_AS_WS","Divehi_90_CS_AS_KS","Divehi_90_CS_AS_KS_WS","Estonian_BIN","Estonian_BIN2","Estonian_CI_AI","Estonian_CI_AI_WS","Estonian_CI_AI_KS","Estonian_CI_AI_KS_WS","Estonian_CI_AS","Estonian_CI_AS_WS","Estonian_CI_AS_KS","Estonian_CI_AS_KS_WS","Estonian_CS_AI","Estonian_CS_AI_WS","Estonian_CS_AI_KS","Estonian_CS_AI_KS_WS","Estonian_CS_AS","Estonian_CS_AS_WS","Estonian_CS_AS_KS","Estonian_CS_AS_KS_WS","Finnish_Swedish_BIN","Finnish_Swedish_BIN2","Finnish_Swedish_CI_AI","Finnish_Swedish_CI_AI_WS","Finnish_Swedish_CI_AI_KS","Finnish_Swedish_CI_AI_KS_WS","Finnish_Swedish_CI_AS","Finnish_Swedish_CI_AS_WS","Finnish_Swedish_CI_AS_KS","Finnish_Swedish_CI_AS_KS_WS","Finnish_Swedish_CS_AI","Finnish_Swedish_CS_AI_WS","Finnish_Swedish_CS_AI_KS","Finnish_Swedish_CS_AI_KS_WS","Finnish_Swedish_CS_AS","Finnish_Swedish_CS_AS_WS","Finnish_Swedish_CS_AS_KS","Finnish_Swedish_CS_AS_KS_WS","French_BIN","French_BIN2","French_CI_AI","French_CI_AI_WS","French_CI_AI_KS","French_CI_AI_KS_WS","French_CI_AS","French_CI_AS_WS","French_CI_AS_KS","French_CI_AS_KS_WS","French_CS_AI","French_CS_AI_WS","French_CS_AI_KS","French_CS_AI_KS_WS","French_CS_AS","French_CS_AS_WS","French_CS_AS_KS","French_CS_AS_KS_WS","Georgian_Modern_Sort_BIN","Georgian_Modern_Sort_BIN2","Georgian_Modern_Sort_CI_AI","Georgian_Modern_Sort_CI_AI_WS","Georgian_Modern_Sort_CI_AI_KS","Georgian_Modern_Sort_CI_AI_KS_WS","Georgian_Modern_Sort_CI_AS","Georgian_Modern_Sort_CI_AS_WS","Georgian_Modern_Sort_CI_AS_KS","Georgian_Modern_Sort_CI_AS_KS_WS","Georgian_Modern_Sort_CS_AI","Georgian_Modern_Sort_CS_AI_WS","Georgian_Modern_Sort_CS_AI_KS","Georgian_Modern_Sort_CS_AI_KS_WS","Georgian_Modern_Sort_CS_AS","Georgian_Modern_Sort_CS_AS_WS","Georgian_Modern_Sort_CS_AS_KS","Georgian_Modern_Sort_CS_AS_KS_WS","German_PhoneBook_BIN","German_PhoneBook_BIN2","German_PhoneBook_CI_AI","German_PhoneBook_CI_AI_WS","German_PhoneBook_CI_AI_KS","German_PhoneBook_CI_AI_KS_WS","German_PhoneBook_CI_AS","German_PhoneBook_CI_AS_WS","German_PhoneBook_CI_AS_KS","German_PhoneBook_CI_AS_KS_WS","German_PhoneBook_CS_AI","German_PhoneBook_CS_AI_WS","German_PhoneBook_CS_AI_KS","German_PhoneBook_CS_AI_KS_WS","German_PhoneBook_CS_AS","German_PhoneBook_CS_AS_WS","German_PhoneBook_CS_AS_KS","German_PhoneBook_CS_AS_KS_WS","Greek_BIN","Greek_BIN2","Greek_CI_AI","Greek_CI_AI_WS","Greek_CI_AI_KS","Greek_CI_AI_KS_WS","Greek_CI_AS","Greek_CI_AS_WS","Greek_CI_AS_KS","Greek_CI_AS_KS_WS","Greek_CS_AI","Greek_CS_AI_WS","Greek_CS_AI_KS","Greek_CS_AI_KS_WS","Greek_CS_AS","Greek_CS_AS_WS","Greek_CS_AS_KS","Greek_CS_AS_KS_WS","Hebrew_BIN","Hebrew_BIN2","Hebrew_CI_AI","Hebrew_CI_AI_WS","Hebrew_CI_AI_KS","Hebrew_CI_AI_KS_WS","Hebrew_CI_AS","Hebrew_CI_AS_WS","Hebrew_CI_AS_KS","Hebrew_CI_AS_KS_WS","Hebrew_CS_AI","Hebrew_CS_AI_WS","Hebrew_CS_AI_KS","Hebrew_CS_AI_KS_WS","Hebrew_CS_AS","Hebrew_CS_AS_WS","Hebrew_CS_AS_KS","Hebrew_CS_AS_KS_WS","Hungarian_BIN","Hungarian_BIN2","Hungarian_CI_AI","Hungarian_CI_AI_WS","Hungarian_CI_AI_KS","Hungarian_CI_AI_KS_WS","Hungarian_CI_AS","Hungarian_CI_AS_WS","Hungarian_CI_AS_KS","Hungarian_CI_AS_KS_WS","Hungarian_CS_AI","Hungarian_CS_AI_WS","Hungarian_CS_AI_KS","Hungarian_CS_AI_KS_WS","Hungarian_CS_AS","Hungarian_CS_AS_WS","Hungarian_CS_AS_KS","Hungarian_CS_AS_KS_WS","Hungarian_Technical_BIN","Hungarian_Technical_BIN2","Hungarian_Technical_CI_AI","Hungarian_Technical_CI_AI_WS","Hungarian_Technical_CI_AI_KS","Hungarian_Technical_CI_AI_KS_WS","Hungarian_Technical_CI_AS","Hungarian_Technical_CI_AS_WS","Hungarian_Technical_CI_AS_KS","Hungarian_Technical_CI_AS_KS_WS","Hungarian_Technical_CS_AI","Hungarian_Technical_CS_AI_WS","Hungarian_Technical_CS_AI_KS","Hungarian_Technical_CS_AI_KS_WS","Hungarian_Technical_CS_AS","Hungarian_Technical_CS_AS_WS","Hungarian_Technical_CS_AS_KS","Hungarian_Technical_CS_AS_KS_WS","Icelandic_BIN","Icelandic_BIN2","Icelandic_CI_AI","Icelandic_CI_AI_WS","Icelandic_CI_AI_KS","Icelandic_CI_AI_KS_WS","Icelandic_CI_AS","Icelandic_CI_AS_WS","Icelandic_CI_AS_KS","Icelandic_CI_AS_KS_WS","Icelandic_CS_AI","Icelandic_CS_AI_WS","Icelandic_CS_AI_KS","Icelandic_CS_AI_KS_WS","Icelandic_CS_AS","Icelandic_CS_AS_WS","Icelandic_CS_AS_KS","Icelandic_CS_AS_KS_WS","Indic_General_90_BIN","Indic_General_90_BIN2","Indic_General_90_CI_AI","Indic_General_90_CI_AI_WS","Indic_General_90_CI_AI_KS","Indic_General_90_CI_AI_KS_WS","Indic_General_90_CI_AS","Indic_General_90_CI_AS_WS","Indic_General_90_CI_AS_KS","Indic_General_90_CI_AS_KS_WS","Indic_General_90_CS_AI","Indic_General_90_CS_AI_WS","Indic_General_90_CS_AI_KS","Indic_General_90_CS_AI_KS_WS","Indic_General_90_CS_AS","Indic_General_90_CS_AS_WS","Indic_General_90_CS_AS_KS","Indic_General_90_CS_AS_KS_WS","Japanese_BIN","Japanese_BIN2","Japanese_CI_AI","Japanese_CI_AI_WS","Japanese_CI_AI_KS","Japanese_CI_AI_KS_WS","Japanese_CI_AS","Japanese_CI_AS_WS","Japanese_CI_AS_KS","Japanese_CI_AS_KS_WS","Japanese_CS_AI","Japanese_CS_AI_WS","Japanese_CS_AI_KS","Japanese_CS_AI_KS_WS","Japanese_CS_AS","Japanese_CS_AS_WS","Japanese_CS_AS_KS","Japanese_CS_AS_KS_WS","Japanese_90_BIN","Japanese_90_BIN2","Japanese_90_CI_AI","Japanese_90_CI_AI_WS","Japanese_90_CI_AI_KS","Japanese_90_CI_AI_KS_WS","Japanese_90_CI_AS","Japanese_90_CI_AS_WS","Japanese_90_CI_AS_KS","Japanese_90_CI_AS_KS_WS","Japanese_90_CS_AI","Japanese_90_CS_AI_WS","Japanese_90_CS_AI_KS","Japanese_90_CS_AI_KS_WS","Japanese_90_CS_AS","Japanese_90_CS_AS_WS","Japanese_90_CS_AS_KS","Japanese_90_CS_AS_KS_WS","Japanese_Unicode_BIN","Japanese_Unicode_BIN2","Japanese_Unicode_CI_AI","Japanese_Unicode_CI_AI_WS","Japanese_Unicode_CI_AI_KS","Japanese_Unicode_CI_AI_KS_WS","Japanese_Unicode_CI_AS","Japanese_Unicode_CI_AS_WS","Japanese_Unicode_CI_AS_KS","Japanese_Unicode_CI_AS_KS_WS","Japanese_Unicode_CS_AI","Japanese_Unicode_CS_AI_WS","Japanese_Unicode_CS_AI_KS","Japanese_Unicode_CS_AI_KS_WS","Japanese_Unicode_CS_AS","Japanese_Unicode_CS_AS_WS","Japanese_Unicode_CS_AS_KS","Japanese_Unicode_CS_AS_KS_WS","Kazakh_90_BIN","Kazakh_90_BIN2","Kazakh_90_CI_AI","Kazakh_90_CI_AI_WS","Kazakh_90_CI_AI_KS","Kazakh_90_CI_AI_KS_WS","Kazakh_90_CI_AS","Kazakh_90_CI_AS_WS","Kazakh_90_CI_AS_KS","Kazakh_90_CI_AS_KS_WS","Kazakh_90_CS_AI","Kazakh_90_CS_AI_WS","Kazakh_90_CS_AI_KS","Kazakh_90_CS_AI_KS_WS","Kazakh_90_CS_AS","Kazakh_90_CS_AS_WS","Kazakh_90_CS_AS_KS","Kazakh_90_CS_AS_KS_WS","Korean_90_BIN","Korean_90_BIN2","Korean_90_CI_AI","Korean_90_CI_AI_WS","Korean_90_CI_AI_KS","Korean_90_CI_AI_KS_WS","Korean_90_CI_AS","Korean_90_CI_AS_WS","Korean_90_CI_AS_KS","Korean_90_CI_AS_KS_WS","Korean_90_CS_AI","Korean_90_CS_AI_WS","Korean_90_CS_AI_KS","Korean_90_CS_AI_KS_WS","Korean_90_CS_AS","Korean_90_CS_AS_WS","Korean_90_CS_AS_KS","Korean_90_CS_AS_KS_WS","Korean_Wansung_BIN","Korean_Wansung_BIN2","Korean_Wansung_CI_AI","Korean_Wansung_CI_AI_WS","Korean_Wansung_CI_AI_KS","Korean_Wansung_CI_AI_KS_WS","Korean_Wansung_CI_AS","Korean_Wansung_CI_AS_WS","Korean_Wansung_CI_AS_KS","Korean_Wansung_CI_AS_KS_WS","Korean_Wansung_CS_AI","Korean_Wansung_CS_AI_WS","Korean_Wansung_CS_AI_KS","Korean_Wansung_CS_AI_KS_WS","Korean_Wansung_CS_AS","Korean_Wansung_CS_AS_WS","Korean_Wansung_CS_AS_KS","Korean_Wansung_CS_AS_KS_WS","Latin1_General_BIN","Latin1_General_BIN2","Latin1_General_CI_AI","Latin1_General_CI_AI_WS","Latin1_General_CI_AI_KS","Latin1_General_CI_AI_KS_WS","Latin1_General_CI_AS","Latin1_General_CI_AS_WS","Latin1_General_CI_AS_KS","Latin1_General_CI_AS_KS_WS","Latin1_General_CS_AI","Latin1_General_CS_AI_WS","Latin1_General_CS_AI_KS","Latin1_General_CS_AI_KS_WS","Latin1_General_CS_AS","Latin1_General_CS_AS_WS","Latin1_General_CS_AS_KS","Latin1_General_CS_AS_KS_WS","Latvian_BIN","Latvian_BIN2","Latvian_CI_AI","Latvian_CI_AI_WS","Latvian_CI_AI_KS","Latvian_CI_AI_KS_WS","Latvian_CI_AS","Latvian_CI_AS_WS","Latvian_CI_AS_KS","Latvian_CI_AS_KS_WS","Latvian_CS_AI","Latvian_CS_AI_WS","Latvian_CS_AI_KS","Latvian_CS_AI_KS_WS","Latvian_CS_AS","Latvian_CS_AS_WS","Latvian_CS_AS_KS","Latvian_CS_AS_KS_WS","Lithuanian_BIN","Lithuanian_BIN2","Lithuanian_CI_AI","Lithuanian_CI_AI_WS","Lithuanian_CI_AI_KS","Lithuanian_CI_AI_KS_WS","Lithuanian_CI_AS","Lithuanian_CI_AS_WS","Lithuanian_CI_AS_KS","Lithuanian_CI_AS_KS_WS","Lithuanian_CS_AI","Lithuanian_CS_AI_WS","Lithuanian_CS_AI_KS","Lithuanian_CS_AI_KS_WS","Lithuanian_CS_AS","Lithuanian_CS_AS_WS","Lithuanian_CS_AS_KS","Lithuanian_CS_AS_KS_WS","Macedonian_FYROM_90_BIN","Macedonian_FYROM_90_BIN2","Macedonian_FYROM_90_CI_AI","Macedonian_FYROM_90_CI_AI_WS","Macedonian_FYROM_90_CI_AI_KS","Macedonian_FYROM_90_CI_AI_KS_WS","Macedonian_FYROM_90_CI_AS","Macedonian_FYROM_90_CI_AS_WS","Macedonian_FYROM_90_CI_AS_KS","Macedonian_FYROM_90_CI_AS_KS_WS","Macedonian_FYROM_90_CS_AI","Macedonian_FYROM_90_CS_AI_WS","Macedonian_FYROM_90_CS_AI_KS","Macedonian_FYROM_90_CS_AI_KS_WS","Macedonian_FYROM_90_CS_AS","Macedonian_FYROM_90_CS_AS_WS","Macedonian_FYROM_90_CS_AS_KS","Macedonian_FYROM_90_CS_AS_KS_WS","Modern_Spanish_BIN","Modern_Spanish_BIN2","Modern_Spanish_CI_AI","Modern_Spanish_CI_AI_WS","Modern_Spanish_CI_AI_KS","Modern_Spanish_CI_AI_KS_WS","Modern_Spanish_CI_AS","Modern_Spanish_CI_AS_WS","Modern_Spanish_CI_AS_KS","Modern_Spanish_CI_AS_KS_WS","Modern_Spanish_CS_AI","Modern_Spanish_CS_AI_WS","Modern_Spanish_CS_AI_KS","Modern_Spanish_CS_AI_KS_WS","Modern_Spanish_CS_AS","Modern_Spanish_CS_AS_WS","Modern_Spanish_CS_AS_KS","Modern_Spanish_CS_AS_KS_WS","Polish_BIN","Polish_BIN2","Polish_CI_AI","Polish_CI_AI_WS","Polish_CI_AI_KS","Polish_CI_AI_KS_WS","Polish_CI_AS","Polish_CI_AS_WS","Polish_CI_AS_KS","Polish_CI_AS_KS_WS","Polish_CS_AI","Polish_CS_AI_WS","Polish_CS_AI_KS","Polish_CS_AI_KS_WS","Polish_CS_AS","Polish_CS_AS_WS","Polish_CS_AS_KS","Polish_CS_AS_KS_WS","Romanian_BIN","Romanian_BIN2","Romanian_CI_AI","Romanian_CI_AI_WS","Romanian_CI_AI_KS","Romanian_CI_AI_KS_WS","Romanian_CI_AS","Romanian_CI_AS_WS","Romanian_CI_AS_KS","Romanian_CI_AS_KS_WS","Romanian_CS_AI","Romanian_CS_AI_WS","Romanian_CS_AI_KS","Romanian_CS_AI_KS_WS","Romanian_CS_AS","Romanian_CS_AS_WS","Romanian_CS_AS_KS","Romanian_CS_AS_KS_WS","Slovak_BIN","Slovak_BIN2","Slovak_CI_AI","Slovak_CI_AI_WS","Slovak_CI_AI_KS","Slovak_CI_AI_KS_WS","Slovak_CI_AS","Slovak_CI_AS_WS","Slovak_CI_AS_KS","Slovak_CI_AS_KS_WS","Slovak_CS_AI","Slovak_CS_AI_WS","Slovak_CS_AI_KS","Slovak_CS_AI_KS_WS","Slovak_CS_AS","Slovak_CS_AS_WS","Slovak_CS_AS_KS","Slovak_CS_AS_KS_WS","Slovenian_BIN","Slovenian_BIN2","Slovenian_CI_AI","Slovenian_CI_AI_WS","Slovenian_CI_AI_KS","Slovenian_CI_AI_KS_WS","Slovenian_CI_AS","Slovenian_CI_AS_WS","Slovenian_CI_AS_KS","Slovenian_CI_AS_KS_WS","Slovenian_CS_AI","Slovenian_CS_AI_WS","Slovenian_CS_AI_KS","Slovenian_CS_AI_KS_WS","Slovenian_CS_AS","Slovenian_CS_AS_WS","Slovenian_CS_AS_KS","Slovenian_CS_AS_KS_WS","Syriac_90_BIN","Syriac_90_BIN2","Syriac_90_CI_AI","Syriac_90_CI_AI_WS","Syriac_90_CI_AI_KS","Syriac_90_CI_AI_KS_WS","Syriac_90_CI_AS","Syriac_90_CI_AS_WS","Syriac_90_CI_AS_KS","Syriac_90_CI_AS_KS_WS","Syriac_90_CS_AI","Syriac_90_CS_AI_WS","Syriac_90_CS_AI_KS","Syriac_90_CS_AI_KS_WS","Syriac_90_CS_AS","Syriac_90_CS_AS_WS","Syriac_90_CS_AS_KS","Syriac_90_CS_AS_KS_WS","Tatar_90_BIN","Tatar_90_BIN2","Tatar_90_CI_AI","Tatar_90_CI_AI_WS","Tatar_90_CI_AI_KS","Tatar_90_CI_AI_KS_WS","Tatar_90_CI_AS","Tatar_90_CI_AS_WS","Tatar_90_CI_AS_KS","Tatar_90_CI_AS_KS_WS","Tatar_90_CS_AI","Tatar_90_CS_AI_WS","Tatar_90_CS_AI_KS","Tatar_90_CS_AI_KS_WS","Tatar_90_CS_AS","Tatar_90_CS_AS_WS","Tatar_90_CS_AS_KS","Tatar_90_CS_AS_KS_WS","Thai_BIN","Thai_BIN2","Thai_CI_AI","Thai_CI_AI_WS","Thai_CI_AI_KS","Thai_CI_AI_KS_WS","Thai_CI_AS","Thai_CI_AS_WS","Thai_CI_AS_KS","Thai_CI_AS_KS_WS","Thai_CS_AI","Thai_CS_AI_WS","Thai_CS_AI_KS","Thai_CS_AI_KS_WS","Thai_CS_AS","Thai_CS_AS_WS","Thai_CS_AS_KS","Thai_CS_AS_KS_WS","Traditional_Spanish_BIN","Traditional_Spanish_BIN2","Traditional_Spanish_CI_AI","Traditional_Spanish_CI_AI_WS","Traditional_Spanish_CI_AI_KS","Traditional_Spanish_CI_AI_KS_WS","Traditional_Spanish_CI_AS","Traditional_Spanish_CI_AS_WS","Traditional_Spanish_CI_AS_KS","Traditional_Spanish_CI_AS_KS_WS","Traditional_Spanish_CS_AI","Traditional_Spanish_CS_AI_WS","Traditional_Spanish_CS_AI_KS","Traditional_Spanish_CS_AI_KS_WS","Traditional_Spanish_CS_AS","Traditional_Spanish_CS_AS_WS","Traditional_Spanish_CS_AS_KS","Traditional_Spanish_CS_AS_KS_WS","Turkish_BIN","Turkish_BIN2","Turkish_CI_AI","Turkish_CI_AI_WS","Turkish_CI_AI_KS","Turkish_CI_AI_KS_WS","Turkish_CI_AS","Turkish_CI_AS_WS","Turkish_CI_AS_KS","Turkish_CI_AS_KS_WS","Turkish_CS_AI","Turkish_CS_AI_WS","Turkish_CS_AI_KS","Turkish_CS_AI_KS_WS","Turkish_CS_AS","Turkish_CS_AS_WS","Turkish_CS_AS_KS","Turkish_CS_AS_KS_WS","Ukrainian_BIN","Ukrainian_BIN2","Ukrainian_CI_AI","Ukrainian_CI_AI_WS","Ukrainian_CI_AI_KS","Ukrainian_CI_AI_KS_WS","Ukrainian_CI_AS","Ukrainian_CI_AS_WS","Ukrainian_CI_AS_KS","Ukrainian_CI_AS_KS_WS","Ukrainian_CS_AI","Ukrainian_CS_AI_WS","Ukrainian_CS_AI_KS","Ukrainian_CS_AI_KS_WS","Ukrainian_CS_AS","Ukrainian_CS_AS_WS","Ukrainian_CS_AS_KS","Ukrainian_CS_AS_KS_WS","Uzbek_Latin_90_BIN","Uzbek_Latin_90_BIN2","Uzbek_Latin_90_CI_AI","Uzbek_Latin_90_CI_AI_WS","Uzbek_Latin_90_CI_AI_KS","Uzbek_Latin_90_CI_AI_KS_WS","Uzbek_Latin_90_CI_AS","Uzbek_Latin_90_CI_AS_WS","Uzbek_Latin_90_CI_AS_KS","Uzbek_Latin_90_CI_AS_KS_WS","Uzbek_Latin_90_CS_AI","Uzbek_Latin_90_CS_AI_WS","Uzbek_Latin_90_CS_AI_KS","Uzbek_Latin_90_CS_AI_KS_WS","Uzbek_Latin_90_CS_AS","Uzbek_Latin_90_CS_AS_WS","Uzbek_Latin_90_CS_AS_KS","Uzbek_Latin_90_CS_AS_KS_WS","Vietnamese_BIN","Vietnamese_BIN2","Vietnamese_CI_AI","Vietnamese_CI_AI_WS","Vietnamese_CI_AI_KS","Vietnamese_CI_AI_KS_WS","Vietnamese_CI_AS","Vietnamese_CI_AS_WS","Vietnamese_CI_AS_KS","Vietnamese_CI_AS_KS_WS","Vietnamese_CS_AI","Vietnamese_CS_AI_WS","Vietnamese_CS_AI_KS","Vietnamese_CS_AI_KS_WS","Vietnamese_CS_AS","Vietnamese_CS_AS_WS","Vietnamese_CS_AS_KS","Vietnamese_CS_AS_KS_WS","SQL_1xCompat_CP850_CI_AS","SQL_AltDiction_CP850_CI_AI","SQL_AltDiction_CP850_CI_AS","SQL_AltDiction_CP850_CS_AS","SQL_AltDiction_Pref_CP850_CI_AS","SQL_AltDiction2_CP1253_CS_AS","SQL_Croatian_CP1250_CI_AS","SQL_Croatian_CP1250_CS_AS","SQL_Czech_CP1250_CI_AS","SQL_Czech_CP1250_CS_AS","SQL_Danish_Pref_CP1_CI_AS","SQL_EBCDIC037_CP1_CS_AS","SQL_EBCDIC273_CP1_CS_AS","SQL_EBCDIC277_CP1_CS_AS","SQL_EBCDIC278_CP1_CS_AS","SQL_EBCDIC280_CP1_CS_AS","SQL_EBCDIC284_CP1_CS_AS","SQL_EBCDIC285_CP1_CS_AS","SQL_EBCDIC297_CP1_CS_AS","SQL_Estonian_CP1257_CI_AS","SQL_Estonian_CP1257_CS_AS","SQL_Hungarian_CP1250_CI_AS","SQL_Hungarian_CP1250_CS_AS","SQL_Icelandic_Pref_CP1_CI_AS","SQL_Latin1_General_CP1_CI_AI","SQL_Latin1_General_CP1_CI_AS","SQL_Latin1_General_CP1_CS_AS","SQL_Latin1_General_CP1250_CI_AS","SQL_Latin1_General_CP1250_CS_AS","SQL_Latin1_General_CP1251_CI_AS","SQL_Latin1_General_CP1251_CS_AS","SQL_Latin1_General_CP1253_CI_AI","SQL_Latin1_General_CP1253_CI_AS","SQL_Latin1_General_CP1253_CS_AS","SQL_Latin1_General_CP1254_CI_AS","SQL_Latin1_General_CP1254_CS_AS","SQL_Latin1_General_CP1255_CI_AS","SQL_Latin1_General_CP1255_CS_AS","SQL_Latin1_General_CP1256_CI_AS","SQL_Latin1_General_CP1256_CS_AS","SQL_Latin1_General_CP1257_CI_AS","SQL_Latin1_General_CP1257_CS_AS","SQL_Latin1_General_CP437_BIN","SQL_Latin1_General_CP437_BIN2","SQL_Latin1_General_CP437_CI_AI","SQL_Latin1_General_CP437_CI_AS","SQL_Latin1_General_CP437_CS_AS","SQL_Latin1_General_CP850_BIN","SQL_Latin1_General_CP850_BIN2","SQL_Latin1_General_CP850_CI_AI","SQL_Latin1_General_CP850_CI_AS","SQL_Latin1_General_CP850_CS_AS","SQL_Latin1_General_Pref_CP1_CI_AS","SQL_Latin1_General_Pref_CP437_CI_AS","SQL_Latin1_General_Pref_CP850_CI_AS","SQL_Latvian_CP1257_CI_AS","SQL_Latvian_CP1257_CS_AS","SQL_Lithuanian_CP1257_CI_AS","SQL_Lithuanian_CP1257_CS_AS","SQL_MixDiction_CP1253_CS_AS","SQL_Polish_CP1250_CI_AS","SQL_Polish_CP1250_CS_AS","SQL_Romanian_CP1250_CI_AS","SQL_Romanian_CP1250_CS_AS","SQL_Scandinavian_CP850_CI_AS","SQL_Scandinavian_CP850_CS_AS","SQL_Scandinavian_Pref_CP850_CI_AS","SQL_Slovak_CP1250_CI_AS","SQL_Slovak_CP1250_CS_AS","SQL_Slovenian_CP1250_CI_AS","SQL_Slovenian_CP1250_CS_AS","SQL_SwedishPhone_Pref_CP1_CI_AS","SQL_SwedishStd_Pref_CP1_CI_AS","SQL_Ukrainian_CP1251_CI_AS","SQL_Ukrainian_CP1251_CS_AS"
	$col2008 = "Albanian_BIN","Albanian_BIN2","Albanian_CI_AI","Albanian_CI_AI_WS","Albanian_CI_AI_KS","Albanian_CI_AI_KS_WS","Albanian_CI_AS","Albanian_CI_AS_WS","Albanian_CI_AS_KS","Albanian_CI_AS_KS_WS","Albanian_CS_AI","Albanian_CS_AI_WS","Albanian_CS_AI_KS","Albanian_CS_AI_KS_WS","Albanian_CS_AS","Albanian_CS_AS_WS","Albanian_CS_AS_KS","Albanian_CS_AS_KS_WS","Albanian_100_BIN","Albanian_100_BIN2","Albanian_100_CI_AI","Albanian_100_CI_AI_WS","Albanian_100_CI_AI_KS","Albanian_100_CI_AI_KS_WS","Albanian_100_CI_AS","Albanian_100_CI_AS_WS","Albanian_100_CI_AS_KS","Albanian_100_CI_AS_KS_WS","Albanian_100_CS_AI","Albanian_100_CS_AI_WS","Albanian_100_CS_AI_KS","Albanian_100_CS_AI_KS_WS","Albanian_100_CS_AS","Albanian_100_CS_AS_WS","Albanian_100_CS_AS_KS","Albanian_100_CS_AS_KS_WS","Arabic_BIN","Arabic_BIN2","Arabic_CI_AI","Arabic_CI_AI_WS","Arabic_CI_AI_KS","Arabic_CI_AI_KS_WS","Arabic_CI_AS","Arabic_CI_AS_WS","Arabic_CI_AS_KS","Arabic_CI_AS_KS_WS","Arabic_CS_AI","Arabic_CS_AI_WS","Arabic_CS_AI_KS","Arabic_CS_AI_KS_WS","Arabic_CS_AS","Arabic_CS_AS_WS","Arabic_CS_AS_KS","Arabic_CS_AS_KS_WS","Arabic_100_BIN","Arabic_100_BIN2","Arabic_100_CI_AI","Arabic_100_CI_AI_WS","Arabic_100_CI_AI_KS","Arabic_100_CI_AI_KS_WS","Arabic_100_CI_AS","Arabic_100_CI_AS_WS","Arabic_100_CI_AS_KS","Arabic_100_CI_AS_KS_WS","Arabic_100_CS_AI","Arabic_100_CS_AI_WS","Arabic_100_CS_AI_KS","Arabic_100_CS_AI_KS_WS","Arabic_100_CS_AS","Arabic_100_CS_AS_WS","Arabic_100_CS_AS_KS","Arabic_100_CS_AS_KS_WS","Assamese_100_BIN","Assamese_100_BIN2","Assamese_100_CI_AI","Assamese_100_CI_AI_WS","Assamese_100_CI_AI_KS","Assamese_100_CI_AI_KS_WS","Assamese_100_CI_AS","Assamese_100_CI_AS_WS","Assamese_100_CI_AS_KS","Assamese_100_CI_AS_KS_WS","Assamese_100_CS_AI","Assamese_100_CS_AI_WS","Assamese_100_CS_AI_KS","Assamese_100_CS_AI_KS_WS","Assamese_100_CS_AS","Assamese_100_CS_AS_WS","Assamese_100_CS_AS_KS","Assamese_100_CS_AS_KS_WS","Azeri_Cyrillic_100_BIN","Azeri_Cyrillic_100_BIN2","Azeri_Cyrillic_100_CI_AI","Azeri_Cyrillic_100_CI_AI_WS","Azeri_Cyrillic_100_CI_AI_KS","Azeri_Cyrillic_100_CI_AI_KS_WS","Azeri_Cyrillic_100_CI_AS","Azeri_Cyrillic_100_CI_AS_WS","Azeri_Cyrillic_100_CI_AS_KS","Azeri_Cyrillic_100_CI_AS_KS_WS","Azeri_Cyrillic_100_CS_AI","Azeri_Cyrillic_100_CS_AI_WS","Azeri_Cyrillic_100_CS_AI_KS","Azeri_Cyrillic_100_CS_AI_KS_WS","Azeri_Cyrillic_100_CS_AS","Azeri_Cyrillic_100_CS_AS_WS","Azeri_Cyrillic_100_CS_AS_KS","Azeri_Cyrillic_100_CS_AS_KS_WS","Azeri_Latin_100_BIN","Azeri_Latin_100_BIN2","Azeri_Latin_100_CI_AI","Azeri_Latin_100_CI_AI_WS","Azeri_Latin_100_CI_AI_KS","Azeri_Latin_100_CI_AI_KS_WS","Azeri_Latin_100_CI_AS","Azeri_Latin_100_CI_AS_WS","Azeri_Latin_100_CI_AS_KS","Azeri_Latin_100_CI_AS_KS_WS","Azeri_Latin_100_CS_AI","Azeri_Latin_100_CS_AI_WS","Azeri_Latin_100_CS_AI_KS","Azeri_Latin_100_CS_AI_KS_WS","Azeri_Latin_100_CS_AS","Azeri_Latin_100_CS_AS_WS","Azeri_Latin_100_CS_AS_KS","Azeri_Latin_100_CS_AS_KS_WS","Bashkir_100_BIN","Bashkir_100_BIN2","Bashkir_100_CI_AI","Bashkir_100_CI_AI_WS","Bashkir_100_CI_AI_KS","Bashkir_100_CI_AI_KS_WS","Bashkir_100_CI_AS","Bashkir_100_CI_AS_WS","Bashkir_100_CI_AS_KS","Bashkir_100_CI_AS_KS_WS","Bashkir_100_CS_AI","Bashkir_100_CS_AI_WS","Bashkir_100_CS_AI_KS","Bashkir_100_CS_AI_KS_WS","Bashkir_100_CS_AS","Bashkir_100_CS_AS_WS","Bashkir_100_CS_AS_KS","Bashkir_100_CS_AS_KS_WS","Bengali_100_BIN","Bengali_100_BIN2","Bengali_100_CI_AI","Bengali_100_CI_AI_WS","Bengali_100_CI_AI_KS","Bengali_100_CI_AI_KS_WS","Bengali_100_CI_AS","Bengali_100_CI_AS_WS","Bengali_100_CI_AS_KS","Bengali_100_CI_AS_KS_WS","Bengali_100_CS_AI","Bengali_100_CS_AI_WS","Bengali_100_CS_AI_KS","Bengali_100_CS_AI_KS_WS","Bengali_100_CS_AS","Bengali_100_CS_AS_WS","Bengali_100_CS_AS_KS","Bengali_100_CS_AS_KS_WS","Bosnian_Cyrillic_100_BIN","Bosnian_Cyrillic_100_BIN2","Bosnian_Cyrillic_100_CI_AI","Bosnian_Cyrillic_100_CI_AI_WS","Bosnian_Cyrillic_100_CI_AI_KS","Bosnian_Cyrillic_100_CI_AI_KS_WS","Bosnian_Cyrillic_100_CI_AS","Bosnian_Cyrillic_100_CI_AS_WS","Bosnian_Cyrillic_100_CI_AS_KS","Bosnian_Cyrillic_100_CI_AS_KS_WS","Bosnian_Cyrillic_100_CS_AI","Bosnian_Cyrillic_100_CS_AI_WS","Bosnian_Cyrillic_100_CS_AI_KS","Bosnian_Cyrillic_100_CS_AI_KS_WS","Bosnian_Cyrillic_100_CS_AS","Bosnian_Cyrillic_100_CS_AS_WS","Bosnian_Cyrillic_100_CS_AS_KS","Bosnian_Cyrillic_100_CS_AS_KS_WS","Bosnian_Latin_100_BIN","Bosnian_Latin_100_BIN2","Bosnian_Latin_100_CI_AI","Bosnian_Latin_100_CI_AI_WS","Bosnian_Latin_100_CI_AI_KS","Bosnian_Latin_100_CI_AI_KS_WS","Bosnian_Latin_100_CI_AS","Bosnian_Latin_100_CI_AS_WS","Bosnian_Latin_100_CI_AS_KS","Bosnian_Latin_100_CI_AS_KS_WS","Bosnian_Latin_100_CS_AI","Bosnian_Latin_100_CS_AI_WS","Bosnian_Latin_100_CS_AI_KS","Bosnian_Latin_100_CS_AI_KS_WS","Bosnian_Latin_100_CS_AS","Bosnian_Latin_100_CS_AS_WS","Bosnian_Latin_100_CS_AS_KS","Bosnian_Latin_100_CS_AS_KS_WS","Breton_100_BIN","Breton_100_BIN2","Breton_100_CI_AI","Breton_100_CI_AI_WS","Breton_100_CI_AI_KS","Breton_100_CI_AI_KS_WS","Breton_100_CI_AS","Breton_100_CI_AS_WS","Breton_100_CI_AS_KS","Breton_100_CI_AS_KS_WS","Breton_100_CS_AI","Breton_100_CS_AI_WS","Breton_100_CS_AI_KS","Breton_100_CS_AI_KS_WS","Breton_100_CS_AS","Breton_100_CS_AS_WS","Breton_100_CS_AS_KS","Breton_100_CS_AS_KS_WS","Chinese_Hong_Kong_Stroke_90_BIN","Chinese_Hong_Kong_Stroke_90_BIN2","Chinese_Hong_Kong_Stroke_90_CI_AI","Chinese_Hong_Kong_Stroke_90_CI_AI_WS","Chinese_Hong_Kong_Stroke_90_CI_AI_KS","Chinese_Hong_Kong_Stroke_90_CI_AI_KS_WS","Chinese_Hong_Kong_Stroke_90_CI_AS","Chinese_Hong_Kong_Stroke_90_CI_AS_WS","Chinese_Hong_Kong_Stroke_90_CI_AS_KS","Chinese_Hong_Kong_Stroke_90_CI_AS_KS_WS","Chinese_Hong_Kong_Stroke_90_CS_AI","Chinese_Hong_Kong_Stroke_90_CS_AI_WS","Chinese_Hong_Kong_Stroke_90_CS_AI_KS","Chinese_Hong_Kong_Stroke_90_CS_AI_KS_WS","Chinese_Hong_Kong_Stroke_90_CS_AS","Chinese_Hong_Kong_Stroke_90_CS_AS_WS","Chinese_Hong_Kong_Stroke_90_CS_AS_KS","Chinese_Hong_Kong_Stroke_90_CS_AS_KS_WS","Chinese_PRC_BIN","Chinese_PRC_BIN2","Chinese_PRC_CI_AI","Chinese_PRC_CI_AI_WS","Chinese_PRC_CI_AI_KS","Chinese_PRC_CI_AI_KS_WS","Chinese_PRC_CI_AS","Chinese_PRC_CI_AS_WS","Chinese_PRC_CI_AS_KS","Chinese_PRC_CI_AS_KS_WS","Chinese_PRC_CS_AI","Chinese_PRC_CS_AI_WS","Chinese_PRC_CS_AI_KS","Chinese_PRC_CS_AI_KS_WS","Chinese_PRC_CS_AS","Chinese_PRC_CS_AS_WS","Chinese_PRC_CS_AS_KS","Chinese_PRC_CS_AS_KS_WS","Chinese_PRC_90_BIN","Chinese_PRC_90_BIN2","Chinese_PRC_90_CI_AI","Chinese_PRC_90_CI_AI_WS","Chinese_PRC_90_CI_AI_KS","Chinese_PRC_90_CI_AI_KS_WS","Chinese_PRC_90_CI_AS","Chinese_PRC_90_CI_AS_WS","Chinese_PRC_90_CI_AS_KS","Chinese_PRC_90_CI_AS_KS_WS","Chinese_PRC_90_CS_AI","Chinese_PRC_90_CS_AI_WS","Chinese_PRC_90_CS_AI_KS","Chinese_PRC_90_CS_AI_KS_WS","Chinese_PRC_90_CS_AS","Chinese_PRC_90_CS_AS_WS","Chinese_PRC_90_CS_AS_KS","Chinese_PRC_90_CS_AS_KS_WS","Chinese_PRC_Stroke_BIN","Chinese_PRC_Stroke_BIN2","Chinese_PRC_Stroke_CI_AI","Chinese_PRC_Stroke_CI_AI_WS","Chinese_PRC_Stroke_CI_AI_KS","Chinese_PRC_Stroke_CI_AI_KS_WS","Chinese_PRC_Stroke_CI_AS","Chinese_PRC_Stroke_CI_AS_WS","Chinese_PRC_Stroke_CI_AS_KS","Chinese_PRC_Stroke_CI_AS_KS_WS","Chinese_PRC_Stroke_CS_AI","Chinese_PRC_Stroke_CS_AI_WS","Chinese_PRC_Stroke_CS_AI_KS","Chinese_PRC_Stroke_CS_AI_KS_WS","Chinese_PRC_Stroke_CS_AS","Chinese_PRC_Stroke_CS_AS_WS","Chinese_PRC_Stroke_CS_AS_KS","Chinese_PRC_Stroke_CS_AS_KS_WS","Chinese_PRC_Stroke_90_BIN","Chinese_PRC_Stroke_90_BIN2","Chinese_PRC_Stroke_90_CI_AI","Chinese_PRC_Stroke_90_CI_AI_WS","Chinese_PRC_Stroke_90_CI_AI_KS","Chinese_PRC_Stroke_90_CI_AI_KS_WS","Chinese_PRC_Stroke_90_CI_AS","Chinese_PRC_Stroke_90_CI_AS_WS","Chinese_PRC_Stroke_90_CI_AS_KS","Chinese_PRC_Stroke_90_CI_AS_KS_WS","Chinese_PRC_Stroke_90_CS_AI","Chinese_PRC_Stroke_90_CS_AI_WS","Chinese_PRC_Stroke_90_CS_AI_KS","Chinese_PRC_Stroke_90_CS_AI_KS_WS","Chinese_PRC_Stroke_90_CS_AS","Chinese_PRC_Stroke_90_CS_AS_WS","Chinese_PRC_Stroke_90_CS_AS_KS","Chinese_PRC_Stroke_90_CS_AS_KS_WS","Chinese_Simplified_Pinyin_100_BIN","Chinese_Simplified_Pinyin_100_BIN2","Chinese_Simplified_Pinyin_100_CI_AI","Chinese_Simplified_Pinyin_100_CI_AI_WS","Chinese_Simplified_Pinyin_100_CI_AI_KS","Chinese_Simplified_Pinyin_100_CI_AI_KS_WS","Chinese_Simplified_Pinyin_100_CI_AS","Chinese_Simplified_Pinyin_100_CI_AS_WS","Chinese_Simplified_Pinyin_100_CI_AS_KS","Chinese_Simplified_Pinyin_100_CI_AS_KS_WS","Chinese_Simplified_Pinyin_100_CS_AI","Chinese_Simplified_Pinyin_100_CS_AI_WS","Chinese_Simplified_Pinyin_100_CS_AI_KS","Chinese_Simplified_Pinyin_100_CS_AI_KS_WS","Chinese_Simplified_Pinyin_100_CS_AS","Chinese_Simplified_Pinyin_100_CS_AS_WS","Chinese_Simplified_Pinyin_100_CS_AS_KS","Chinese_Simplified_Pinyin_100_CS_AS_KS_WS","Chinese_Simplified_Stroke_Order_100_BIN","Chinese_Simplified_Stroke_Order_100_BIN2","Chinese_Simplified_Stroke_Order_100_CI_AI","Chinese_Simplified_Stroke_Order_100_CI_AI_WS","Chinese_Simplified_Stroke_Order_100_CI_AI_KS","Chinese_Simplified_Stroke_Order_100_CI_AI_KS_WS","Chinese_Simplified_Stroke_Order_100_CI_AS","Chinese_Simplified_Stroke_Order_100_CI_AS_WS","Chinese_Simplified_Stroke_Order_100_CI_AS_KS","Chinese_Simplified_Stroke_Order_100_CI_AS_KS_WS","Chinese_Simplified_Stroke_Order_100_CS_AI","Chinese_Simplified_Stroke_Order_100_CS_AI_WS","Chinese_Simplified_Stroke_Order_100_CS_AI_KS","Chinese_Simplified_Stroke_Order_100_CS_AI_KS_WS","Chinese_Simplified_Stroke_Order_100_CS_AS","Chinese_Simplified_Stroke_Order_100_CS_AS_WS","Chinese_Simplified_Stroke_Order_100_CS_AS_KS","Chinese_Simplified_Stroke_Order_100_CS_AS_KS_WS","Chinese_Taiwan_Bopomofo_BIN","Chinese_Taiwan_Bopomofo_BIN2","Chinese_Taiwan_Bopomofo_CI_AI","Chinese_Taiwan_Bopomofo_CI_AI_WS","Chinese_Taiwan_Bopomofo_CI_AI_KS","Chinese_Taiwan_Bopomofo_CI_AI_KS_WS","Chinese_Taiwan_Bopomofo_CI_AS","Chinese_Taiwan_Bopomofo_CI_AS_WS","Chinese_Taiwan_Bopomofo_CI_AS_KS","Chinese_Taiwan_Bopomofo_CI_AS_KS_WS","Chinese_Taiwan_Bopomofo_CS_AI","Chinese_Taiwan_Bopomofo_CS_AI_WS","Chinese_Taiwan_Bopomofo_CS_AI_KS","Chinese_Taiwan_Bopomofo_CS_AI_KS_WS","Chinese_Taiwan_Bopomofo_CS_AS","Chinese_Taiwan_Bopomofo_CS_AS_WS","Chinese_Taiwan_Bopomofo_CS_AS_KS","Chinese_Taiwan_Bopomofo_CS_AS_KS_WS","Chinese_Taiwan_Bopomofo_90_BIN","Chinese_Taiwan_Bopomofo_90_BIN2","Chinese_Taiwan_Bopomofo_90_CI_AI","Chinese_Taiwan_Bopomofo_90_CI_AI_WS","Chinese_Taiwan_Bopomofo_90_CI_AI_KS","Chinese_Taiwan_Bopomofo_90_CI_AI_KS_WS","Chinese_Taiwan_Bopomofo_90_CI_AS","Chinese_Taiwan_Bopomofo_90_CI_AS_WS","Chinese_Taiwan_Bopomofo_90_CI_AS_KS","Chinese_Taiwan_Bopomofo_90_CI_AS_KS_WS","Chinese_Taiwan_Bopomofo_90_CS_AI","Chinese_Taiwan_Bopomofo_90_CS_AI_WS","Chinese_Taiwan_Bopomofo_90_CS_AI_KS","Chinese_Taiwan_Bopomofo_90_CS_AI_KS_WS","Chinese_Taiwan_Bopomofo_90_CS_AS","Chinese_Taiwan_Bopomofo_90_CS_AS_WS","Chinese_Taiwan_Bopomofo_90_CS_AS_KS","Chinese_Taiwan_Bopomofo_90_CS_AS_KS_WS","Chinese_Taiwan_Stroke_BIN","Chinese_Taiwan_Stroke_BIN2","Chinese_Taiwan_Stroke_CI_AI","Chinese_Taiwan_Stroke_CI_AI_WS","Chinese_Taiwan_Stroke_CI_AI_KS","Chinese_Taiwan_Stroke_CI_AI_KS_WS","Chinese_Taiwan_Stroke_CI_AS","Chinese_Taiwan_Stroke_CI_AS_WS","Chinese_Taiwan_Stroke_CI_AS_KS","Chinese_Taiwan_Stroke_CI_AS_KS_WS","Chinese_Taiwan_Stroke_CS_AI","Chinese_Taiwan_Stroke_CS_AI_WS","Chinese_Taiwan_Stroke_CS_AI_KS","Chinese_Taiwan_Stroke_CS_AI_KS_WS","Chinese_Taiwan_Stroke_CS_AS","Chinese_Taiwan_Stroke_CS_AS_WS","Chinese_Taiwan_Stroke_CS_AS_KS","Chinese_Taiwan_Stroke_CS_AS_KS_WS","Chinese_Taiwan_Stroke_90_BIN","Chinese_Taiwan_Stroke_90_BIN2","Chinese_Taiwan_Stroke_90_CI_AI","Chinese_Taiwan_Stroke_90_CI_AI_WS","Chinese_Taiwan_Stroke_90_CI_AI_KS","Chinese_Taiwan_Stroke_90_CI_AI_KS_WS","Chinese_Taiwan_Stroke_90_CI_AS","Chinese_Taiwan_Stroke_90_CI_AS_WS","Chinese_Taiwan_Stroke_90_CI_AS_KS","Chinese_Taiwan_Stroke_90_CI_AS_KS_WS","Chinese_Taiwan_Stroke_90_CS_AI","Chinese_Taiwan_Stroke_90_CS_AI_WS","Chinese_Taiwan_Stroke_90_CS_AI_KS","Chinese_Taiwan_Stroke_90_CS_AI_KS_WS","Chinese_Taiwan_Stroke_90_CS_AS","Chinese_Taiwan_Stroke_90_CS_AS_WS","Chinese_Taiwan_Stroke_90_CS_AS_KS","Chinese_Taiwan_Stroke_90_CS_AS_KS_WS","Chinese_Traditional_Bopomofo_100_BIN","Chinese_Traditional_Bopomofo_100_BIN2","Chinese_Traditional_Bopomofo_100_CI_AI","Chinese_Traditional_Bopomofo_100_CI_AI_WS","Chinese_Traditional_Bopomofo_100_CI_AI_KS","Chinese_Traditional_Bopomofo_100_CI_AI_KS_WS","Chinese_Traditional_Bopomofo_100_CI_AS","Chinese_Traditional_Bopomofo_100_CI_AS_WS","Chinese_Traditional_Bopomofo_100_CI_AS_KS","Chinese_Traditional_Bopomofo_100_CI_AS_KS_WS","Chinese_Traditional_Bopomofo_100_CS_AI","Chinese_Traditional_Bopomofo_100_CS_AI_WS","Chinese_Traditional_Bopomofo_100_CS_AI_KS","Chinese_Traditional_Bopomofo_100_CS_AI_KS_WS","Chinese_Traditional_Bopomofo_100_CS_AS","Chinese_Traditional_Bopomofo_100_CS_AS_WS","Chinese_Traditional_Bopomofo_100_CS_AS_KS","Chinese_Traditional_Bopomofo_100_CS_AS_KS_WS","Chinese_Traditional_Pinyin_100_BIN","Chinese_Traditional_Pinyin_100_BIN2","Chinese_Traditional_Pinyin_100_CI_AI","Chinese_Traditional_Pinyin_100_CI_AI_WS","Chinese_Traditional_Pinyin_100_CI_AI_KS","Chinese_Traditional_Pinyin_100_CI_AI_KS_WS","Chinese_Traditional_Pinyin_100_CI_AS","Chinese_Traditional_Pinyin_100_CI_AS_WS","Chinese_Traditional_Pinyin_100_CI_AS_KS","Chinese_Traditional_Pinyin_100_CI_AS_KS_WS","Chinese_Traditional_Pinyin_100_CS_AI","Chinese_Traditional_Pinyin_100_CS_AI_WS","Chinese_Traditional_Pinyin_100_CS_AI_KS","Chinese_Traditional_Pinyin_100_CS_AI_KS_WS","Chinese_Traditional_Pinyin_100_CS_AS","Chinese_Traditional_Pinyin_100_CS_AS_WS","Chinese_Traditional_Pinyin_100_CS_AS_KS","Chinese_Traditional_Pinyin_100_CS_AS_KS_WS","Chinese_Traditional_Stroke_Count_100_BIN","Chinese_Traditional_Stroke_Count_100_BIN2","Chinese_Traditional_Stroke_Count_100_CI_AI","Chinese_Traditional_Stroke_Count_100_CI_AI_WS","Chinese_Traditional_Stroke_Count_100_CI_AI_KS","Chinese_Traditional_Stroke_Count_100_CI_AI_KS_WS","Chinese_Traditional_Stroke_Count_100_CI_AS","Chinese_Traditional_Stroke_Count_100_CI_AS_WS","Chinese_Traditional_Stroke_Count_100_CI_AS_KS","Chinese_Traditional_Stroke_Count_100_CI_AS_KS_WS","Chinese_Traditional_Stroke_Count_100_CS_AI","Chinese_Traditional_Stroke_Count_100_CS_AI_WS","Chinese_Traditional_Stroke_Count_100_CS_AI_KS","Chinese_Traditional_Stroke_Count_100_CS_AI_KS_WS","Chinese_Traditional_Stroke_Count_100_CS_AS","Chinese_Traditional_Stroke_Count_100_CS_AS_WS","Chinese_Traditional_Stroke_Count_100_CS_AS_KS","Chinese_Traditional_Stroke_Count_100_CS_AS_KS_WS","Chinese_Traditional_Stroke_Order_100_BIN","Chinese_Traditional_Stroke_Order_100_BIN2","Chinese_Traditional_Stroke_Order_100_CI_AI","Chinese_Traditional_Stroke_Order_100_CI_AI_WS","Chinese_Traditional_Stroke_Order_100_CI_AI_KS","Chinese_Traditional_Stroke_Order_100_CI_AI_KS_WS","Chinese_Traditional_Stroke_Order_100_CI_AS","Chinese_Traditional_Stroke_Order_100_CI_AS_WS","Chinese_Traditional_Stroke_Order_100_CI_AS_KS","Chinese_Traditional_Stroke_Order_100_CI_AS_KS_WS","Chinese_Traditional_Stroke_Order_100_CS_AI","Chinese_Traditional_Stroke_Order_100_CS_AI_WS","Chinese_Traditional_Stroke_Order_100_CS_AI_KS","Chinese_Traditional_Stroke_Order_100_CS_AI_KS_WS","Chinese_Traditional_Stroke_Order_100_CS_AS","Chinese_Traditional_Stroke_Order_100_CS_AS_WS","Chinese_Traditional_Stroke_Order_100_CS_AS_KS","Chinese_Traditional_Stroke_Order_100_CS_AS_KS_WS","Corsican_100_BIN","Corsican_100_BIN2","Corsican_100_CI_AI","Corsican_100_CI_AI_WS","Corsican_100_CI_AI_KS","Corsican_100_CI_AI_KS_WS","Corsican_100_CI_AS","Corsican_100_CI_AS_WS","Corsican_100_CI_AS_KS","Corsican_100_CI_AS_KS_WS","Corsican_100_CS_AI","Corsican_100_CS_AI_WS","Corsican_100_CS_AI_KS","Corsican_100_CS_AI_KS_WS","Corsican_100_CS_AS","Corsican_100_CS_AS_WS","Corsican_100_CS_AS_KS","Corsican_100_CS_AS_KS_WS","Croatian_BIN","Croatian_BIN2","Croatian_CI_AI","Croatian_CI_AI_WS","Croatian_CI_AI_KS","Croatian_CI_AI_KS_WS","Croatian_CI_AS","Croatian_CI_AS_WS","Croatian_CI_AS_KS","Croatian_CI_AS_KS_WS","Croatian_CS_AI","Croatian_CS_AI_WS","Croatian_CS_AI_KS","Croatian_CS_AI_KS_WS","Croatian_CS_AS","Croatian_CS_AS_WS","Croatian_CS_AS_KS","Croatian_CS_AS_KS_WS","Croatian_100_BIN","Croatian_100_BIN2","Croatian_100_CI_AI","Croatian_100_CI_AI_WS","Croatian_100_CI_AI_KS","Croatian_100_CI_AI_KS_WS","Croatian_100_CI_AS","Croatian_100_CI_AS_WS","Croatian_100_CI_AS_KS","Croatian_100_CI_AS_KS_WS","Croatian_100_CS_AI","Croatian_100_CS_AI_WS","Croatian_100_CS_AI_KS","Croatian_100_CS_AI_KS_WS","Croatian_100_CS_AS","Croatian_100_CS_AS_WS","Croatian_100_CS_AS_KS","Croatian_100_CS_AS_KS_WS","Cyrillic_General_BIN","Cyrillic_General_BIN2","Cyrillic_General_CI_AI","Cyrillic_General_CI_AI_WS","Cyrillic_General_CI_AI_KS","Cyrillic_General_CI_AI_KS_WS","Cyrillic_General_CI_AS","Cyrillic_General_CI_AS_WS","Cyrillic_General_CI_AS_KS","Cyrillic_General_CI_AS_KS_WS","Cyrillic_General_CS_AI","Cyrillic_General_CS_AI_WS","Cyrillic_General_CS_AI_KS","Cyrillic_General_CS_AI_KS_WS","Cyrillic_General_CS_AS","Cyrillic_General_CS_AS_WS","Cyrillic_General_CS_AS_KS","Cyrillic_General_CS_AS_KS_WS","Cyrillic_General_100_BIN","Cyrillic_General_100_BIN2","Cyrillic_General_100_CI_AI","Cyrillic_General_100_CI_AI_WS","Cyrillic_General_100_CI_AI_KS","Cyrillic_General_100_CI_AI_KS_WS","Cyrillic_General_100_CI_AS","Cyrillic_General_100_CI_AS_WS","Cyrillic_General_100_CI_AS_KS","Cyrillic_General_100_CI_AS_KS_WS","Cyrillic_General_100_CS_AI","Cyrillic_General_100_CS_AI_WS","Cyrillic_General_100_CS_AI_KS","Cyrillic_General_100_CS_AI_KS_WS","Cyrillic_General_100_CS_AS","Cyrillic_General_100_CS_AS_WS","Cyrillic_General_100_CS_AS_KS","Cyrillic_General_100_CS_AS_KS_WS","Czech_BIN","Czech_BIN2","Czech_CI_AI","Czech_CI_AI_WS","Czech_CI_AI_KS","Czech_CI_AI_KS_WS","Czech_CI_AS","Czech_CI_AS_WS","Czech_CI_AS_KS","Czech_CI_AS_KS_WS","Czech_CS_AI","Czech_CS_AI_WS","Czech_CS_AI_KS","Czech_CS_AI_KS_WS","Czech_CS_AS","Czech_CS_AS_WS","Czech_CS_AS_KS","Czech_CS_AS_KS_WS","Czech_100_BIN","Czech_100_BIN2","Czech_100_CI_AI","Czech_100_CI_AI_WS","Czech_100_CI_AI_KS","Czech_100_CI_AI_KS_WS","Czech_100_CI_AS","Czech_100_CI_AS_WS","Czech_100_CI_AS_KS","Czech_100_CI_AS_KS_WS","Czech_100_CS_AI","Czech_100_CS_AI_WS","Czech_100_CS_AI_KS","Czech_100_CS_AI_KS_WS","Czech_100_CS_AS","Czech_100_CS_AS_WS","Czech_100_CS_AS_KS","Czech_100_CS_AS_KS_WS","Danish_Greenlandic_100_BIN","Danish_Greenlandic_100_BIN2","Danish_Greenlandic_100_CI_AI","Danish_Greenlandic_100_CI_AI_WS","Danish_Greenlandic_100_CI_AI_KS","Danish_Greenlandic_100_CI_AI_KS_WS","Danish_Greenlandic_100_CI_AS","Danish_Greenlandic_100_CI_AS_WS","Danish_Greenlandic_100_CI_AS_KS","Danish_Greenlandic_100_CI_AS_KS_WS","Danish_Greenlandic_100_CS_AI","Danish_Greenlandic_100_CS_AI_WS","Danish_Greenlandic_100_CS_AI_KS","Danish_Greenlandic_100_CS_AI_KS_WS","Danish_Greenlandic_100_CS_AS","Danish_Greenlandic_100_CS_AS_WS","Danish_Greenlandic_100_CS_AS_KS","Danish_Greenlandic_100_CS_AS_KS_WS","Danish_Norwegian_BIN","Danish_Norwegian_BIN2","Danish_Norwegian_CI_AI","Danish_Norwegian_CI_AI_WS","Danish_Norwegian_CI_AI_KS","Danish_Norwegian_CI_AI_KS_WS","Danish_Norwegian_CI_AS","Danish_Norwegian_CI_AS_WS","Danish_Norwegian_CI_AS_KS","Danish_Norwegian_CI_AS_KS_WS","Danish_Norwegian_CS_AI","Danish_Norwegian_CS_AI_WS","Danish_Norwegian_CS_AI_KS","Danish_Norwegian_CS_AI_KS_WS","Danish_Norwegian_CS_AS","Danish_Norwegian_CS_AS_WS","Danish_Norwegian_CS_AS_KS","Danish_Norwegian_CS_AS_KS_WS","Dari_100_BIN","Dari_100_BIN2","Dari_100_CI_AI","Dari_100_CI_AI_WS","Dari_100_CI_AI_KS","Dari_100_CI_AI_KS_WS","Dari_100_CI_AS","Dari_100_CI_AS_WS","Dari_100_CI_AS_KS","Dari_100_CI_AS_KS_WS","Dari_100_CS_AI","Dari_100_CS_AI_WS","Dari_100_CS_AI_KS","Dari_100_CS_AI_KS_WS","Dari_100_CS_AS","Dari_100_CS_AS_WS","Dari_100_CS_AS_KS","Dari_100_CS_AS_KS_WS","Divehi_90_BIN","Divehi_90_BIN2","Divehi_90_CI_AI","Divehi_90_CI_AI_WS","Divehi_90_CI_AI_KS","Divehi_90_CI_AI_KS_WS","Divehi_90_CI_AS","Divehi_90_CI_AS_WS","Divehi_90_CI_AS_KS","Divehi_90_CI_AS_KS_WS","Divehi_90_CS_AI","Divehi_90_CS_AI_WS","Divehi_90_CS_AI_KS","Divehi_90_CS_AI_KS_WS","Divehi_90_CS_AS","Divehi_90_CS_AS_WS","Divehi_90_CS_AS_KS","Divehi_90_CS_AS_KS_WS","Divehi_100_BIN","Divehi_100_BIN2","Divehi_100_CI_AI","Divehi_100_CI_AI_WS","Divehi_100_CI_AI_KS","Divehi_100_CI_AI_KS_WS","Divehi_100_CI_AS","Divehi_100_CI_AS_WS","Divehi_100_CI_AS_KS","Divehi_100_CI_AS_KS_WS","Divehi_100_CS_AI","Divehi_100_CS_AI_WS","Divehi_100_CS_AI_KS","Divehi_100_CS_AI_KS_WS","Divehi_100_CS_AS","Divehi_100_CS_AS_WS","Divehi_100_CS_AS_KS","Divehi_100_CS_AS_KS_WS","Estonian_BIN","Estonian_BIN2","Estonian_CI_AI","Estonian_CI_AI_WS","Estonian_CI_AI_KS","Estonian_CI_AI_KS_WS","Estonian_CI_AS","Estonian_CI_AS_WS","Estonian_CI_AS_KS","Estonian_CI_AS_KS_WS","Estonian_CS_AI","Estonian_CS_AI_WS","Estonian_CS_AI_KS","Estonian_CS_AI_KS_WS","Estonian_CS_AS","Estonian_CS_AS_WS","Estonian_CS_AS_KS","Estonian_CS_AS_KS_WS","Estonian_100_BIN","Estonian_100_BIN2","Estonian_100_CI_AI","Estonian_100_CI_AI_WS","Estonian_100_CI_AI_KS","Estonian_100_CI_AI_KS_WS","Estonian_100_CI_AS","Estonian_100_CI_AS_WS","Estonian_100_CI_AS_KS","Estonian_100_CI_AS_KS_WS","Estonian_100_CS_AI","Estonian_100_CS_AI_WS","Estonian_100_CS_AI_KS","Estonian_100_CS_AI_KS_WS","Estonian_100_CS_AS","Estonian_100_CS_AS_WS","Estonian_100_CS_AS_KS","Estonian_100_CS_AS_KS_WS","Finnish_Swedish_BIN","Finnish_Swedish_BIN2","Finnish_Swedish_CI_AI","Finnish_Swedish_CI_AI_WS","Finnish_Swedish_CI_AI_KS","Finnish_Swedish_CI_AI_KS_WS","Finnish_Swedish_CI_AS","Finnish_Swedish_CI_AS_WS","Finnish_Swedish_CI_AS_KS","Finnish_Swedish_CI_AS_KS_WS","Finnish_Swedish_CS_AI","Finnish_Swedish_CS_AI_WS","Finnish_Swedish_CS_AI_KS","Finnish_Swedish_CS_AI_KS_WS","Finnish_Swedish_CS_AS","Finnish_Swedish_CS_AS_WS","Finnish_Swedish_CS_AS_KS","Finnish_Swedish_CS_AS_KS_WS","Finnish_Swedish_100_BIN","Finnish_Swedish_100_BIN2","Finnish_Swedish_100_CI_AI","Finnish_Swedish_100_CI_AI_WS","Finnish_Swedish_100_CI_AI_KS","Finnish_Swedish_100_CI_AI_KS_WS","Finnish_Swedish_100_CI_AS","Finnish_Swedish_100_CI_AS_WS","Finnish_Swedish_100_CI_AS_KS","Finnish_Swedish_100_CI_AS_KS_WS","Finnish_Swedish_100_CS_AI","Finnish_Swedish_100_CS_AI_WS","Finnish_Swedish_100_CS_AI_KS","Finnish_Swedish_100_CS_AI_KS_WS","Finnish_Swedish_100_CS_AS","Finnish_Swedish_100_CS_AS_WS","Finnish_Swedish_100_CS_AS_KS","Finnish_Swedish_100_CS_AS_KS_WS","French_BIN","French_BIN2","French_CI_AI","French_CI_AI_WS","French_CI_AI_KS","French_CI_AI_KS_WS","French_CI_AS","French_CI_AS_WS","French_CI_AS_KS","French_CI_AS_KS_WS","French_CS_AI","French_CS_AI_WS","French_CS_AI_KS","French_CS_AI_KS_WS","French_CS_AS","French_CS_AS_WS","French_CS_AS_KS","French_CS_AS_KS_WS","French_100_BIN","French_100_BIN2","French_100_CI_AI","French_100_CI_AI_WS","French_100_CI_AI_KS","French_100_CI_AI_KS_WS","French_100_CI_AS","French_100_CI_AS_WS","French_100_CI_AS_KS","French_100_CI_AS_KS_WS","French_100_CS_AI","French_100_CS_AI_WS","French_100_CS_AI_KS","French_100_CS_AI_KS_WS","French_100_CS_AS","French_100_CS_AS_WS","French_100_CS_AS_KS","French_100_CS_AS_KS_WS","Frisian_100_BIN","Frisian_100_BIN2","Frisian_100_CI_AI","Frisian_100_CI_AI_WS","Frisian_100_CI_AI_KS","Frisian_100_CI_AI_KS_WS","Frisian_100_CI_AS","Frisian_100_CI_AS_WS","Frisian_100_CI_AS_KS","Frisian_100_CI_AS_KS_WS","Frisian_100_CS_AI","Frisian_100_CS_AI_WS","Frisian_100_CS_AI_KS","Frisian_100_CS_AI_KS_WS","Frisian_100_CS_AS","Frisian_100_CS_AS_WS","Frisian_100_CS_AS_KS","Frisian_100_CS_AS_KS_WS","Georgian_Modern_Sort_BIN","Georgian_Modern_Sort_BIN2","Georgian_Modern_Sort_CI_AI","Georgian_Modern_Sort_CI_AI_WS","Georgian_Modern_Sort_CI_AI_KS","Georgian_Modern_Sort_CI_AI_KS_WS","Georgian_Modern_Sort_CI_AS","Georgian_Modern_Sort_CI_AS_WS","Georgian_Modern_Sort_CI_AS_KS","Georgian_Modern_Sort_CI_AS_KS_WS","Georgian_Modern_Sort_CS_AI","Georgian_Modern_Sort_CS_AI_WS","Georgian_Modern_Sort_CS_AI_KS","Georgian_Modern_Sort_CS_AI_KS_WS","Georgian_Modern_Sort_CS_AS","Georgian_Modern_Sort_CS_AS_WS","Georgian_Modern_Sort_CS_AS_KS","Georgian_Modern_Sort_CS_AS_KS_WS","Georgian_Modern_Sort_100_BIN","Georgian_Modern_Sort_100_BIN2","Georgian_Modern_Sort_100_CI_AI","Georgian_Modern_Sort_100_CI_AI_WS","Georgian_Modern_Sort_100_CI_AI_KS","Georgian_Modern_Sort_100_CI_AI_KS_WS","Georgian_Modern_Sort_100_CI_AS","Georgian_Modern_Sort_100_CI_AS_WS","Georgian_Modern_Sort_100_CI_AS_KS","Georgian_Modern_Sort_100_CI_AS_KS_WS","Georgian_Modern_Sort_100_CS_AI","Georgian_Modern_Sort_100_CS_AI_WS","Georgian_Modern_Sort_100_CS_AI_KS","Georgian_Modern_Sort_100_CS_AI_KS_WS","Georgian_Modern_Sort_100_CS_AS","Georgian_Modern_Sort_100_CS_AS_WS","Georgian_Modern_Sort_100_CS_AS_KS","Georgian_Modern_Sort_100_CS_AS_KS_WS","German_PhoneBook_BIN","German_PhoneBook_BIN2","German_PhoneBook_CI_AI","German_PhoneBook_CI_AI_WS","German_PhoneBook_CI_AI_KS","German_PhoneBook_CI_AI_KS_WS","German_PhoneBook_CI_AS","German_PhoneBook_CI_AS_WS","German_PhoneBook_CI_AS_KS","German_PhoneBook_CI_AS_KS_WS","German_PhoneBook_CS_AI","German_PhoneBook_CS_AI_WS","German_PhoneBook_CS_AI_KS","German_PhoneBook_CS_AI_KS_WS","German_PhoneBook_CS_AS","German_PhoneBook_CS_AS_WS","German_PhoneBook_CS_AS_KS","German_PhoneBook_CS_AS_KS_WS","German_PhoneBook_100_BIN","German_PhoneBook_100_BIN2","German_PhoneBook_100_CI_AI","German_PhoneBook_100_CI_AI_WS","German_PhoneBook_100_CI_AI_KS","German_PhoneBook_100_CI_AI_KS_WS","German_PhoneBook_100_CI_AS","German_PhoneBook_100_CI_AS_WS","German_PhoneBook_100_CI_AS_KS","German_PhoneBook_100_CI_AS_KS_WS","German_PhoneBook_100_CS_AI","German_PhoneBook_100_CS_AI_WS","German_PhoneBook_100_CS_AI_KS","German_PhoneBook_100_CS_AI_KS_WS","German_PhoneBook_100_CS_AS","German_PhoneBook_100_CS_AS_WS","German_PhoneBook_100_CS_AS_KS","German_PhoneBook_100_CS_AS_KS_WS","Greek_BIN","Greek_BIN2","Greek_CI_AI","Greek_CI_AI_WS","Greek_CI_AI_KS","Greek_CI_AI_KS_WS","Greek_CI_AS","Greek_CI_AS_WS","Greek_CI_AS_KS","Greek_CI_AS_KS_WS","Greek_CS_AI","Greek_CS_AI_WS","Greek_CS_AI_KS","Greek_CS_AI_KS_WS","Greek_CS_AS","Greek_CS_AS_WS","Greek_CS_AS_KS","Greek_CS_AS_KS_WS","Greek_100_BIN","Greek_100_BIN2","Greek_100_CI_AI","Greek_100_CI_AI_WS","Greek_100_CI_AI_KS","Greek_100_CI_AI_KS_WS","Greek_100_CI_AS","Greek_100_CI_AS_WS","Greek_100_CI_AS_KS","Greek_100_CI_AS_KS_WS","Greek_100_CS_AI","Greek_100_CS_AI_WS","Greek_100_CS_AI_KS","Greek_100_CS_AI_KS_WS","Greek_100_CS_AS","Greek_100_CS_AS_WS","Greek_100_CS_AS_KS","Greek_100_CS_AS_KS_WS","Hebrew_BIN","Hebrew_BIN2","Hebrew_CI_AI","Hebrew_CI_AI_WS","Hebrew_CI_AI_KS","Hebrew_CI_AI_KS_WS","Hebrew_CI_AS","Hebrew_CI_AS_WS","Hebrew_CI_AS_KS","Hebrew_CI_AS_KS_WS","Hebrew_CS_AI","Hebrew_CS_AI_WS","Hebrew_CS_AI_KS","Hebrew_CS_AI_KS_WS","Hebrew_CS_AS","Hebrew_CS_AS_WS","Hebrew_CS_AS_KS","Hebrew_CS_AS_KS_WS","Hebrew_100_BIN","Hebrew_100_BIN2","Hebrew_100_CI_AI","Hebrew_100_CI_AI_WS","Hebrew_100_CI_AI_KS","Hebrew_100_CI_AI_KS_WS","Hebrew_100_CI_AS","Hebrew_100_CI_AS_WS","Hebrew_100_CI_AS_KS","Hebrew_100_CI_AS_KS_WS","Hebrew_100_CS_AI","Hebrew_100_CS_AI_WS","Hebrew_100_CS_AI_KS","Hebrew_100_CS_AI_KS_WS","Hebrew_100_CS_AS","Hebrew_100_CS_AS_WS","Hebrew_100_CS_AS_KS","Hebrew_100_CS_AS_KS_WS","Hungarian_BIN","Hungarian_BIN2","Hungarian_CI_AI","Hungarian_CI_AI_WS","Hungarian_CI_AI_KS","Hungarian_CI_AI_KS_WS","Hungarian_CI_AS","Hungarian_CI_AS_WS","Hungarian_CI_AS_KS","Hungarian_CI_AS_KS_WS","Hungarian_CS_AI","Hungarian_CS_AI_WS","Hungarian_CS_AI_KS","Hungarian_CS_AI_KS_WS","Hungarian_CS_AS","Hungarian_CS_AS_WS","Hungarian_CS_AS_KS","Hungarian_CS_AS_KS_WS","Hungarian_100_BIN","Hungarian_100_BIN2","Hungarian_100_CI_AI","Hungarian_100_CI_AI_WS","Hungarian_100_CI_AI_KS","Hungarian_100_CI_AI_KS_WS","Hungarian_100_CI_AS","Hungarian_100_CI_AS_WS","Hungarian_100_CI_AS_KS","Hungarian_100_CI_AS_KS_WS","Hungarian_100_CS_AI","Hungarian_100_CS_AI_WS","Hungarian_100_CS_AI_KS","Hungarian_100_CS_AI_KS_WS","Hungarian_100_CS_AS","Hungarian_100_CS_AS_WS","Hungarian_100_CS_AS_KS","Hungarian_100_CS_AS_KS_WS","Hungarian_Technical_BIN","Hungarian_Technical_BIN2","Hungarian_Technical_CI_AI","Hungarian_Technical_CI_AI_WS","Hungarian_Technical_CI_AI_KS","Hungarian_Technical_CI_AI_KS_WS","Hungarian_Technical_CI_AS","Hungarian_Technical_CI_AS_WS","Hungarian_Technical_CI_AS_KS","Hungarian_Technical_CI_AS_KS_WS","Hungarian_Technical_CS_AI","Hungarian_Technical_CS_AI_WS","Hungarian_Technical_CS_AI_KS","Hungarian_Technical_CS_AI_KS_WS","Hungarian_Technical_CS_AS","Hungarian_Technical_CS_AS_WS","Hungarian_Technical_CS_AS_KS","Hungarian_Technical_CS_AS_KS_WS","Hungarian_Technical_100_BIN","Hungarian_Technical_100_BIN2","Hungarian_Technical_100_CI_AI","Hungarian_Technical_100_CI_AI_WS","Hungarian_Technical_100_CI_AI_KS","Hungarian_Technical_100_CI_AI_KS_WS","Hungarian_Technical_100_CI_AS","Hungarian_Technical_100_CI_AS_WS","Hungarian_Technical_100_CI_AS_KS","Hungarian_Technical_100_CI_AS_KS_WS","Hungarian_Technical_100_CS_AI","Hungarian_Technical_100_CS_AI_WS","Hungarian_Technical_100_CS_AI_KS","Hungarian_Technical_100_CS_AI_KS_WS","Hungarian_Technical_100_CS_AS","Hungarian_Technical_100_CS_AS_WS","Hungarian_Technical_100_CS_AS_KS","Hungarian_Technical_100_CS_AS_KS_WS","Icelandic_BIN","Icelandic_BIN2","Icelandic_CI_AI","Icelandic_CI_AI_WS","Icelandic_CI_AI_KS","Icelandic_CI_AI_KS_WS","Icelandic_CI_AS","Icelandic_CI_AS_WS","Icelandic_CI_AS_KS","Icelandic_CI_AS_KS_WS","Icelandic_CS_AI","Icelandic_CS_AI_WS","Icelandic_CS_AI_KS","Icelandic_CS_AI_KS_WS","Icelandic_CS_AS","Icelandic_CS_AS_WS","Icelandic_CS_AS_KS","Icelandic_CS_AS_KS_WS","Icelandic_100_BIN","Icelandic_100_BIN2","Icelandic_100_CI_AI","Icelandic_100_CI_AI_WS","Icelandic_100_CI_AI_KS","Icelandic_100_CI_AI_KS_WS","Icelandic_100_CI_AS","Icelandic_100_CI_AS_WS","Icelandic_100_CI_AS_KS","Icelandic_100_CI_AS_KS_WS","Icelandic_100_CS_AI","Icelandic_100_CS_AI_WS","Icelandic_100_CS_AI_KS","Icelandic_100_CS_AI_KS_WS","Icelandic_100_CS_AS","Icelandic_100_CS_AS_WS","Icelandic_100_CS_AS_KS","Icelandic_100_CS_AS_KS_WS","Indic_General_90_BIN","Indic_General_90_BIN2","Indic_General_90_CI_AI","Indic_General_90_CI_AI_WS","Indic_General_90_CI_AI_KS","Indic_General_90_CI_AI_KS_WS","Indic_General_90_CI_AS","Indic_General_90_CI_AS_WS","Indic_General_90_CI_AS_KS","Indic_General_90_CI_AS_KS_WS","Indic_General_90_CS_AI","Indic_General_90_CS_AI_WS","Indic_General_90_CS_AI_KS","Indic_General_90_CS_AI_KS_WS","Indic_General_90_CS_AS","Indic_General_90_CS_AS_WS","Indic_General_90_CS_AS_KS","Indic_General_90_CS_AS_KS_WS","Indic_General_100_BIN","Indic_General_100_BIN2","Indic_General_100_CI_AI","Indic_General_100_CI_AI_WS","Indic_General_100_CI_AI_KS","Indic_General_100_CI_AI_KS_WS","Indic_General_100_CI_AS","Indic_General_100_CI_AS_WS","Indic_General_100_CI_AS_KS","Indic_General_100_CI_AS_KS_WS","Indic_General_100_CS_AI","Indic_General_100_CS_AI_WS","Indic_General_100_CS_AI_KS","Indic_General_100_CS_AI_KS_WS","Indic_General_100_CS_AS","Indic_General_100_CS_AS_WS","Indic_General_100_CS_AS_KS","Indic_General_100_CS_AS_KS_WS","Japanese_BIN","Japanese_BIN2","Japanese_CI_AI","Japanese_CI_AI_WS","Japanese_CI_AI_KS","Japanese_CI_AI_KS_WS","Japanese_CI_AS","Japanese_CI_AS_WS","Japanese_CI_AS_KS","Japanese_CI_AS_KS_WS","Japanese_CS_AI","Japanese_CS_AI_WS","Japanese_CS_AI_KS","Japanese_CS_AI_KS_WS","Japanese_CS_AS","Japanese_CS_AS_WS","Japanese_CS_AS_KS","Japanese_CS_AS_KS_WS","Japanese_90_BIN","Japanese_90_BIN2","Japanese_90_CI_AI","Japanese_90_CI_AI_WS","Japanese_90_CI_AI_KS","Japanese_90_CI_AI_KS_WS","Japanese_90_CI_AS","Japanese_90_CI_AS_WS","Japanese_90_CI_AS_KS","Japanese_90_CI_AS_KS_WS","Japanese_90_CS_AI","Japanese_90_CS_AI_WS","Japanese_90_CS_AI_KS","Japanese_90_CS_AI_KS_WS","Japanese_90_CS_AS","Japanese_90_CS_AS_WS","Japanese_90_CS_AS_KS","Japanese_90_CS_AS_KS_WS","Japanese_Bushu_Kakusu_100_BIN","Japanese_Bushu_Kakusu_100_BIN2","Japanese_Bushu_Kakusu_100_CI_AI","Japanese_Bushu_Kakusu_100_CI_AI_WS","Japanese_Bushu_Kakusu_100_CI_AI_KS","Japanese_Bushu_Kakusu_100_CI_AI_KS_WS","Japanese_Bushu_Kakusu_100_CI_AS","Japanese_Bushu_Kakusu_100_CI_AS_WS","Japanese_Bushu_Kakusu_100_CI_AS_KS","Japanese_Bushu_Kakusu_100_CI_AS_KS_WS","Japanese_Bushu_Kakusu_100_CS_AI","Japanese_Bushu_Kakusu_100_CS_AI_WS","Japanese_Bushu_Kakusu_100_CS_AI_KS","Japanese_Bushu_Kakusu_100_CS_AI_KS_WS","Japanese_Bushu_Kakusu_100_CS_AS","Japanese_Bushu_Kakusu_100_CS_AS_WS","Japanese_Bushu_Kakusu_100_CS_AS_KS","Japanese_Bushu_Kakusu_100_CS_AS_KS_WS","Japanese_Unicode_BIN","Japanese_Unicode_BIN2","Japanese_Unicode_CI_AI","Japanese_Unicode_CI_AI_WS","Japanese_Unicode_CI_AI_KS","Japanese_Unicode_CI_AI_KS_WS","Japanese_Unicode_CI_AS","Japanese_Unicode_CI_AS_WS","Japanese_Unicode_CI_AS_KS","Japanese_Unicode_CI_AS_KS_WS","Japanese_Unicode_CS_AI","Japanese_Unicode_CS_AI_WS","Japanese_Unicode_CS_AI_KS","Japanese_Unicode_CS_AI_KS_WS","Japanese_Unicode_CS_AS","Japanese_Unicode_CS_AS_WS","Japanese_Unicode_CS_AS_KS","Japanese_Unicode_CS_AS_KS_WS","Japanese_XJIS_100_BIN","Japanese_XJIS_100_BIN2","Japanese_XJIS_100_CI_AI","Japanese_XJIS_100_CI_AI_WS","Japanese_XJIS_100_CI_AI_KS","Japanese_XJIS_100_CI_AI_KS_WS",
	"Japanese_XJIS_100_CI_AS","Japanese_XJIS_100_CI_AS_WS","Japanese_XJIS_100_CI_AS_KS","Japanese_XJIS_100_CI_AS_KS_WS","Japanese_XJIS_100_CS_AI","Japanese_XJIS_100_CS_AI_WS","Japanese_XJIS_100_CS_AI_KS","Japanese_XJIS_100_CS_AI_KS_WS","Japanese_XJIS_100_CS_AS","Japanese_XJIS_100_CS_AS_WS","Japanese_XJIS_100_CS_AS_KS","Japanese_XJIS_100_CS_AS_KS_WS","Kazakh_90_BIN","Kazakh_90_BIN2","Kazakh_90_CI_AI","Kazakh_90_CI_AI_WS","Kazakh_90_CI_AI_KS","Kazakh_90_CI_AI_KS_WS","Kazakh_90_CI_AS","Kazakh_90_CI_AS_WS","Kazakh_90_CI_AS_KS","Kazakh_90_CI_AS_KS_WS","Kazakh_90_CS_AI","Kazakh_90_CS_AI_WS","Kazakh_90_CS_AI_KS","Kazakh_90_CS_AI_KS_WS","Kazakh_90_CS_AS","Kazakh_90_CS_AS_WS","Kazakh_90_CS_AS_KS","Kazakh_90_CS_AS_KS_WS","Kazakh_100_BIN","Kazakh_100_BIN2","Kazakh_100_CI_AI","Kazakh_100_CI_AI_WS","Kazakh_100_CI_AI_KS","Kazakh_100_CI_AI_KS_WS","Kazakh_100_CI_AS","Kazakh_100_CI_AS_WS","Kazakh_100_CI_AS_KS","Kazakh_100_CI_AS_KS_WS","Kazakh_100_CS_AI","Kazakh_100_CS_AI_WS","Kazakh_100_CS_AI_KS","Kazakh_100_CS_AI_KS_WS","Kazakh_100_CS_AS","Kazakh_100_CS_AS_WS","Kazakh_100_CS_AS_KS","Kazakh_100_CS_AS_KS_WS","Khmer_100_BIN","Khmer_100_BIN2","Khmer_100_CI_AI","Khmer_100_CI_AI_WS","Khmer_100_CI_AI_KS","Khmer_100_CI_AI_KS_WS","Khmer_100_CI_AS","Khmer_100_CI_AS_WS","Khmer_100_CI_AS_KS","Khmer_100_CI_AS_KS_WS","Khmer_100_CS_AI","Khmer_100_CS_AI_WS","Khmer_100_CS_AI_KS","Khmer_100_CS_AI_KS_WS","Khmer_100_CS_AS","Khmer_100_CS_AS_WS","Khmer_100_CS_AS_KS","Khmer_100_CS_AS_KS_WS","Korean_90_BIN","Korean_90_BIN2","Korean_90_CI_AI","Korean_90_CI_AI_WS","Korean_90_CI_AI_KS","Korean_90_CI_AI_KS_WS","Korean_90_CI_AS","Korean_90_CI_AS_WS","Korean_90_CI_AS_KS","Korean_90_CI_AS_KS_WS","Korean_90_CS_AI","Korean_90_CS_AI_WS","Korean_90_CS_AI_KS","Korean_90_CS_AI_KS_WS","Korean_90_CS_AS","Korean_90_CS_AS_WS","Korean_90_CS_AS_KS","Korean_90_CS_AS_KS_WS","Korean_100_BIN","Korean_100_BIN2","Korean_100_CI_AI","Korean_100_CI_AI_WS","Korean_100_CI_AI_KS","Korean_100_CI_AI_KS_WS","Korean_100_CI_AS","Korean_100_CI_AS_WS","Korean_100_CI_AS_KS","Korean_100_CI_AS_KS_WS","Korean_100_CS_AI","Korean_100_CS_AI_WS","Korean_100_CS_AI_KS","Korean_100_CS_AI_KS_WS","Korean_100_CS_AS","Korean_100_CS_AS_WS","Korean_100_CS_AS_KS","Korean_100_CS_AS_KS_WS","Korean_Wansung_BIN","Korean_Wansung_BIN2","Korean_Wansung_CI_AI","Korean_Wansung_CI_AI_WS","Korean_Wansung_CI_AI_KS","Korean_Wansung_CI_AI_KS_WS","Korean_Wansung_CI_AS","Korean_Wansung_CI_AS_WS","Korean_Wansung_CI_AS_KS","Korean_Wansung_CI_AS_KS_WS","Korean_Wansung_CS_AI","Korean_Wansung_CS_AI_WS","Korean_Wansung_CS_AI_KS","Korean_Wansung_CS_AI_KS_WS","Korean_Wansung_CS_AS","Korean_Wansung_CS_AS_WS","Korean_Wansung_CS_AS_KS","Korean_Wansung_CS_AS_KS_WS","Lao_100_BIN","Lao_100_BIN2","Lao_100_CI_AI","Lao_100_CI_AI_WS","Lao_100_CI_AI_KS","Lao_100_CI_AI_KS_WS","Lao_100_CI_AS","Lao_100_CI_AS_WS","Lao_100_CI_AS_KS","Lao_100_CI_AS_KS_WS","Lao_100_CS_AI","Lao_100_CS_AI_WS","Lao_100_CS_AI_KS","Lao_100_CS_AI_KS_WS","Lao_100_CS_AS","Lao_100_CS_AS_WS","Lao_100_CS_AS_KS","Lao_100_CS_AS_KS_WS","Latin1_General_BIN","Latin1_General_BIN2","Latin1_General_CI_AI","Latin1_General_CI_AI_WS","Latin1_General_CI_AI_KS","Latin1_General_CI_AI_KS_WS","Latin1_General_CI_AS","Latin1_General_CI_AS_WS","Latin1_General_CI_AS_KS","Latin1_General_CI_AS_KS_WS","Latin1_General_CS_AI","Latin1_General_CS_AI_WS","Latin1_General_CS_AI_KS","Latin1_General_CS_AI_KS_WS","Latin1_General_CS_AS","Latin1_General_CS_AS_WS","Latin1_General_CS_AS_KS","Latin1_General_CS_AS_KS_WS","Latin1_General_100_BIN","Latin1_General_100_BIN2","Latin1_General_100_CI_AI","Latin1_General_100_CI_AI_WS","Latin1_General_100_CI_AI_KS","Latin1_General_100_CI_AI_KS_WS","Latin1_General_100_CI_AS","Latin1_General_100_CI_AS_WS","Latin1_General_100_CI_AS_KS","Latin1_General_100_CI_AS_KS_WS","Latin1_General_100_CS_AI","Latin1_General_100_CS_AI_WS","Latin1_General_100_CS_AI_KS","Latin1_General_100_CS_AI_KS_WS","Latin1_General_100_CS_AS","Latin1_General_100_CS_AS_WS","Latin1_General_100_CS_AS_KS","Latin1_General_100_CS_AS_KS_WS","Latvian_BIN","Latvian_BIN2","Latvian_CI_AI","Latvian_CI_AI_WS","Latvian_CI_AI_KS","Latvian_CI_AI_KS_WS","Latvian_CI_AS","Latvian_CI_AS_WS","Latvian_CI_AS_KS","Latvian_CI_AS_KS_WS","Latvian_CS_AI","Latvian_CS_AI_WS","Latvian_CS_AI_KS","Latvian_CS_AI_KS_WS","Latvian_CS_AS","Latvian_CS_AS_WS","Latvian_CS_AS_KS","Latvian_CS_AS_KS_WS","Latvian_100_BIN","Latvian_100_BIN2","Latvian_100_CI_AI","Latvian_100_CI_AI_WS","Latvian_100_CI_AI_KS","Latvian_100_CI_AI_KS_WS","Latvian_100_CI_AS","Latvian_100_CI_AS_WS","Latvian_100_CI_AS_KS","Latvian_100_CI_AS_KS_WS","Latvian_100_CS_AI","Latvian_100_CS_AI_WS","Latvian_100_CS_AI_KS","Latvian_100_CS_AI_KS_WS","Latvian_100_CS_AS","Latvian_100_CS_AS_WS","Latvian_100_CS_AS_KS","Latvian_100_CS_AS_KS_WS","Lithuanian_BIN","Lithuanian_BIN2","Lithuanian_CI_AI","Lithuanian_CI_AI_WS","Lithuanian_CI_AI_KS","Lithuanian_CI_AI_KS_WS","Lithuanian_CI_AS","Lithuanian_CI_AS_WS","Lithuanian_CI_AS_KS","Lithuanian_CI_AS_KS_WS","Lithuanian_CS_AI","Lithuanian_CS_AI_WS","Lithuanian_CS_AI_KS","Lithuanian_CS_AI_KS_WS","Lithuanian_CS_AS","Lithuanian_CS_AS_WS","Lithuanian_CS_AS_KS","Lithuanian_CS_AS_KS_WS","Lithuanian_100_BIN","Lithuanian_100_BIN2","Lithuanian_100_CI_AI","Lithuanian_100_CI_AI_WS","Lithuanian_100_CI_AI_KS","Lithuanian_100_CI_AI_KS_WS","Lithuanian_100_CI_AS","Lithuanian_100_CI_AS_WS","Lithuanian_100_CI_AS_KS","Lithuanian_100_CI_AS_KS_WS","Lithuanian_100_CS_AI","Lithuanian_100_CS_AI_WS","Lithuanian_100_CS_AI_KS","Lithuanian_100_CS_AI_KS_WS","Lithuanian_100_CS_AS","Lithuanian_100_CS_AS_WS","Lithuanian_100_CS_AS_KS","Lithuanian_100_CS_AS_KS_WS","Macedonian_FYROM_90_BIN","Macedonian_FYROM_90_BIN2","Macedonian_FYROM_90_CI_AI","Macedonian_FYROM_90_CI_AI_WS","Macedonian_FYROM_90_CI_AI_KS","Macedonian_FYROM_90_CI_AI_KS_WS","Macedonian_FYROM_90_CI_AS","Macedonian_FYROM_90_CI_AS_WS","Macedonian_FYROM_90_CI_AS_KS","Macedonian_FYROM_90_CI_AS_KS_WS","Macedonian_FYROM_90_CS_AI","Macedonian_FYROM_90_CS_AI_WS","Macedonian_FYROM_90_CS_AI_KS","Macedonian_FYROM_90_CS_AI_KS_WS","Macedonian_FYROM_90_CS_AS","Macedonian_FYROM_90_CS_AS_WS","Macedonian_FYROM_90_CS_AS_KS","Macedonian_FYROM_90_CS_AS_KS_WS","Macedonian_FYROM_100_BIN","Macedonian_FYROM_100_BIN2","Macedonian_FYROM_100_CI_AI","Macedonian_FYROM_100_CI_AI_WS","Macedonian_FYROM_100_CI_AI_KS","Macedonian_FYROM_100_CI_AI_KS_WS","Macedonian_FYROM_100_CI_AS","Macedonian_FYROM_100_CI_AS_WS","Macedonian_FYROM_100_CI_AS_KS","Macedonian_FYROM_100_CI_AS_KS_WS","Macedonian_FYROM_100_CS_AI","Macedonian_FYROM_100_CS_AI_WS","Macedonian_FYROM_100_CS_AI_KS","Macedonian_FYROM_100_CS_AI_KS_WS","Macedonian_FYROM_100_CS_AS","Macedonian_FYROM_100_CS_AS_WS","Macedonian_FYROM_100_CS_AS_KS","Macedonian_FYROM_100_CS_AS_KS_WS","Maltese_100_BIN","Maltese_100_BIN2","Maltese_100_CI_AI","Maltese_100_CI_AI_WS","Maltese_100_CI_AI_KS","Maltese_100_CI_AI_KS_WS","Maltese_100_CI_AS","Maltese_100_CI_AS_WS","Maltese_100_CI_AS_KS","Maltese_100_CI_AS_KS_WS","Maltese_100_CS_AI","Maltese_100_CS_AI_WS","Maltese_100_CS_AI_KS","Maltese_100_CS_AI_KS_WS","Maltese_100_CS_AS","Maltese_100_CS_AS_WS","Maltese_100_CS_AS_KS","Maltese_100_CS_AS_KS_WS","Maori_100_BIN","Maori_100_BIN2","Maori_100_CI_AI","Maori_100_CI_AI_WS","Maori_100_CI_AI_KS","Maori_100_CI_AI_KS_WS","Maori_100_CI_AS","Maori_100_CI_AS_WS","Maori_100_CI_AS_KS","Maori_100_CI_AS_KS_WS","Maori_100_CS_AI","Maori_100_CS_AI_WS","Maori_100_CS_AI_KS","Maori_100_CS_AI_KS_WS","Maori_100_CS_AS","Maori_100_CS_AS_WS","Maori_100_CS_AS_KS","Maori_100_CS_AS_KS_WS","Mapudungan_100_BIN","Mapudungan_100_BIN2","Mapudungan_100_CI_AI","Mapudungan_100_CI_AI_WS","Mapudungan_100_CI_AI_KS","Mapudungan_100_CI_AI_KS_WS","Mapudungan_100_CI_AS","Mapudungan_100_CI_AS_WS","Mapudungan_100_CI_AS_KS","Mapudungan_100_CI_AS_KS_WS","Mapudungan_100_CS_AI","Mapudungan_100_CS_AI_WS","Mapudungan_100_CS_AI_KS","Mapudungan_100_CS_AI_KS_WS","Mapudungan_100_CS_AS","Mapudungan_100_CS_AS_WS","Mapudungan_100_CS_AS_KS","Mapudungan_100_CS_AS_KS_WS","Modern_Spanish_BIN","Modern_Spanish_BIN2","Modern_Spanish_CI_AI","Modern_Spanish_CI_AI_WS","Modern_Spanish_CI_AI_KS","Modern_Spanish_CI_AI_KS_WS","Modern_Spanish_CI_AS","Modern_Spanish_CI_AS_WS","Modern_Spanish_CI_AS_KS","Modern_Spanish_CI_AS_KS_WS","Modern_Spanish_CS_AI","Modern_Spanish_CS_AI_WS","Modern_Spanish_CS_AI_KS","Modern_Spanish_CS_AI_KS_WS","Modern_Spanish_CS_AS","Modern_Spanish_CS_AS_WS","Modern_Spanish_CS_AS_KS","Modern_Spanish_CS_AS_KS_WS","Modern_Spanish_100_BIN","Modern_Spanish_100_BIN2","Modern_Spanish_100_CI_AI","Modern_Spanish_100_CI_AI_WS","Modern_Spanish_100_CI_AI_KS","Modern_Spanish_100_CI_AI_KS_WS","Modern_Spanish_100_CI_AS","Modern_Spanish_100_CI_AS_WS","Modern_Spanish_100_CI_AS_KS","Modern_Spanish_100_CI_AS_KS_WS","Modern_Spanish_100_CS_AI","Modern_Spanish_100_CS_AI_WS","Modern_Spanish_100_CS_AI_KS","Modern_Spanish_100_CS_AI_KS_WS","Modern_Spanish_100_CS_AS","Modern_Spanish_100_CS_AS_WS","Modern_Spanish_100_CS_AS_KS","Modern_Spanish_100_CS_AS_KS_WS","Mohawk_100_BIN","Mohawk_100_BIN2","Mohawk_100_CI_AI","Mohawk_100_CI_AI_WS","Mohawk_100_CI_AI_KS","Mohawk_100_CI_AI_KS_WS","Mohawk_100_CI_AS","Mohawk_100_CI_AS_WS","Mohawk_100_CI_AS_KS","Mohawk_100_CI_AS_KS_WS","Mohawk_100_CS_AI","Mohawk_100_CS_AI_WS","Mohawk_100_CS_AI_KS","Mohawk_100_CS_AI_KS_WS","Mohawk_100_CS_AS","Mohawk_100_CS_AS_WS","Mohawk_100_CS_AS_KS","Mohawk_100_CS_AS_KS_WS","Nepali_100_BIN","Nepali_100_BIN2","Nepali_100_CI_AI","Nepali_100_CI_AI_WS","Nepali_100_CI_AI_KS","Nepali_100_CI_AI_KS_WS","Nepali_100_CI_AS","Nepali_100_CI_AS_WS","Nepali_100_CI_AS_KS","Nepali_100_CI_AS_KS_WS","Nepali_100_CS_AI","Nepali_100_CS_AI_WS","Nepali_100_CS_AI_KS","Nepali_100_CS_AI_KS_WS","Nepali_100_CS_AS","Nepali_100_CS_AS_WS","Nepali_100_CS_AS_KS","Nepali_100_CS_AS_KS_WS","Norwegian_100_BIN","Norwegian_100_BIN2","Norwegian_100_CI_AI","Norwegian_100_CI_AI_WS","Norwegian_100_CI_AI_KS","Norwegian_100_CI_AI_KS_WS","Norwegian_100_CI_AS","Norwegian_100_CI_AS_WS","Norwegian_100_CI_AS_KS","Norwegian_100_CI_AS_KS_WS","Norwegian_100_CS_AI","Norwegian_100_CS_AI_WS","Norwegian_100_CS_AI_KS","Norwegian_100_CS_AI_KS_WS","Norwegian_100_CS_AS","Norwegian_100_CS_AS_WS","Norwegian_100_CS_AS_KS","Norwegian_100_CS_AS_KS_WS","Pashto_100_BIN","Pashto_100_BIN2","Pashto_100_CI_AI","Pashto_100_CI_AI_WS","Pashto_100_CI_AI_KS","Pashto_100_CI_AI_KS_WS","Pashto_100_CI_AS","Pashto_100_CI_AS_WS","Pashto_100_CI_AS_KS","Pashto_100_CI_AS_KS_WS","Pashto_100_CS_AI","Pashto_100_CS_AI_WS","Pashto_100_CS_AI_KS","Pashto_100_CS_AI_KS_WS","Pashto_100_CS_AS","Pashto_100_CS_AS_WS","Pashto_100_CS_AS_KS","Pashto_100_CS_AS_KS_WS","Persian_100_BIN","Persian_100_BIN2","Persian_100_CI_AI","Persian_100_CI_AI_WS","Persian_100_CI_AI_KS","Persian_100_CI_AI_KS_WS","Persian_100_CI_AS","Persian_100_CI_AS_WS","Persian_100_CI_AS_KS","Persian_100_CI_AS_KS_WS","Persian_100_CS_AI","Persian_100_CS_AI_WS","Persian_100_CS_AI_KS","Persian_100_CS_AI_KS_WS","Persian_100_CS_AS","Persian_100_CS_AS_WS","Persian_100_CS_AS_KS","Persian_100_CS_AS_KS_WS","Polish_BIN","Polish_BIN2","Polish_CI_AI","Polish_CI_AI_WS","Polish_CI_AI_KS","Polish_CI_AI_KS_WS","Polish_CI_AS","Polish_CI_AS_WS","Polish_CI_AS_KS","Polish_CI_AS_KS_WS","Polish_CS_AI","Polish_CS_AI_WS","Polish_CS_AI_KS","Polish_CS_AI_KS_WS","Polish_CS_AS","Polish_CS_AS_WS","Polish_CS_AS_KS","Polish_CS_AS_KS_WS","Polish_100_BIN","Polish_100_BIN2","Polish_100_CI_AI","Polish_100_CI_AI_WS","Polish_100_CI_AI_KS","Polish_100_CI_AI_KS_WS","Polish_100_CI_AS","Polish_100_CI_AS_WS","Polish_100_CI_AS_KS","Polish_100_CI_AS_KS_WS","Polish_100_CS_AI","Polish_100_CS_AI_WS","Polish_100_CS_AI_KS","Polish_100_CS_AI_KS_WS","Polish_100_CS_AS","Polish_100_CS_AS_WS","Polish_100_CS_AS_KS","Polish_100_CS_AS_KS_WS","Romanian_BIN","Romanian_BIN2","Romanian_CI_AI","Romanian_CI_AI_WS","Romanian_CI_AI_KS","Romanian_CI_AI_KS_WS","Romanian_CI_AS","Romanian_CI_AS_WS","Romanian_CI_AS_KS","Romanian_CI_AS_KS_WS","Romanian_CS_AI","Romanian_CS_AI_WS","Romanian_CS_AI_KS","Romanian_CS_AI_KS_WS","Romanian_CS_AS","Romanian_CS_AS_WS","Romanian_CS_AS_KS","Romanian_CS_AS_KS_WS","Romanian_100_BIN","Romanian_100_BIN2","Romanian_100_CI_AI","Romanian_100_CI_AI_WS","Romanian_100_CI_AI_KS","Romanian_100_CI_AI_KS_WS","Romanian_100_CI_AS","Romanian_100_CI_AS_WS","Romanian_100_CI_AS_KS","Romanian_100_CI_AS_KS_WS","Romanian_100_CS_AI","Romanian_100_CS_AI_WS","Romanian_100_CS_AI_KS","Romanian_100_CS_AI_KS_WS","Romanian_100_CS_AS","Romanian_100_CS_AS_WS","Romanian_100_CS_AS_KS","Romanian_100_CS_AS_KS_WS","Romansh_100_BIN","Romansh_100_BIN2","Romansh_100_CI_AI","Romansh_100_CI_AI_WS","Romansh_100_CI_AI_KS","Romansh_100_CI_AI_KS_WS","Romansh_100_CI_AS","Romansh_100_CI_AS_WS","Romansh_100_CI_AS_KS","Romansh_100_CI_AS_KS_WS","Romansh_100_CS_AI","Romansh_100_CS_AI_WS","Romansh_100_CS_AI_KS","Romansh_100_CS_AI_KS_WS","Romansh_100_CS_AS","Romansh_100_CS_AS_WS","Romansh_100_CS_AS_KS","Romansh_100_CS_AS_KS_WS","Sami_Norway_100_BIN","Sami_Norway_100_BIN2","Sami_Norway_100_CI_AI","Sami_Norway_100_CI_AI_WS","Sami_Norway_100_CI_AI_KS","Sami_Norway_100_CI_AI_KS_WS","Sami_Norway_100_CI_AS","Sami_Norway_100_CI_AS_WS","Sami_Norway_100_CI_AS_KS","Sami_Norway_100_CI_AS_KS_WS","Sami_Norway_100_CS_AI","Sami_Norway_100_CS_AI_WS","Sami_Norway_100_CS_AI_KS","Sami_Norway_100_CS_AI_KS_WS","Sami_Norway_100_CS_AS","Sami_Norway_100_CS_AS_WS","Sami_Norway_100_CS_AS_KS","Sami_Norway_100_CS_AS_KS_WS","Sami_Sweden_Finland_100_BIN","Sami_Sweden_Finland_100_BIN2","Sami_Sweden_Finland_100_CI_AI","Sami_Sweden_Finland_100_CI_AI_WS","Sami_Sweden_Finland_100_CI_AI_KS","Sami_Sweden_Finland_100_CI_AI_KS_WS","Sami_Sweden_Finland_100_CI_AS","Sami_Sweden_Finland_100_CI_AS_WS","Sami_Sweden_Finland_100_CI_AS_KS","Sami_Sweden_Finland_100_CI_AS_KS_WS","Sami_Sweden_Finland_100_CS_AI","Sami_Sweden_Finland_100_CS_AI_WS","Sami_Sweden_Finland_100_CS_AI_KS","Sami_Sweden_Finland_100_CS_AI_KS_WS","Sami_Sweden_Finland_100_CS_AS","Sami_Sweden_Finland_100_CS_AS_WS","Sami_Sweden_Finland_100_CS_AS_KS","Sami_Sweden_Finland_100_CS_AS_KS_WS","Serbian_Cyrillic_100_BIN","Serbian_Cyrillic_100_BIN2","Serbian_Cyrillic_100_CI_AI","Serbian_Cyrillic_100_CI_AI_WS","Serbian_Cyrillic_100_CI_AI_KS","Serbian_Cyrillic_100_CI_AI_KS_WS","Serbian_Cyrillic_100_CI_AS","Serbian_Cyrillic_100_CI_AS_WS","Serbian_Cyrillic_100_CI_AS_KS","Serbian_Cyrillic_100_CI_AS_KS_WS","Serbian_Cyrillic_100_CS_AI","Serbian_Cyrillic_100_CS_AI_WS","Serbian_Cyrillic_100_CS_AI_KS","Serbian_Cyrillic_100_CS_AI_KS_WS","Serbian_Cyrillic_100_CS_AS","Serbian_Cyrillic_100_CS_AS_WS","Serbian_Cyrillic_100_CS_AS_KS","Serbian_Cyrillic_100_CS_AS_KS_WS","Serbian_Latin_100_BIN","Serbian_Latin_100_BIN2","Serbian_Latin_100_CI_AI","Serbian_Latin_100_CI_AI_WS","Serbian_Latin_100_CI_AI_KS","Serbian_Latin_100_CI_AI_KS_WS","Serbian_Latin_100_CI_AS","Serbian_Latin_100_CI_AS_WS","Serbian_Latin_100_CI_AS_KS","Serbian_Latin_100_CI_AS_KS_WS","Serbian_Latin_100_CS_AI","Serbian_Latin_100_CS_AI_WS","Serbian_Latin_100_CS_AI_KS","Serbian_Latin_100_CS_AI_KS_WS","Serbian_Latin_100_CS_AS","Serbian_Latin_100_CS_AS_WS","Serbian_Latin_100_CS_AS_KS","Serbian_Latin_100_CS_AS_KS_WS","Slovak_BIN","Slovak_BIN2","Slovak_CI_AI","Slovak_CI_AI_WS","Slovak_CI_AI_KS","Slovak_CI_AI_KS_WS","Slovak_CI_AS","Slovak_CI_AS_WS","Slovak_CI_AS_KS","Slovak_CI_AS_KS_WS","Slovak_CS_AI","Slovak_CS_AI_WS","Slovak_CS_AI_KS","Slovak_CS_AI_KS_WS","Slovak_CS_AS","Slovak_CS_AS_WS","Slovak_CS_AS_KS","Slovak_CS_AS_KS_WS","Slovak_100_BIN","Slovak_100_BIN2","Slovak_100_CI_AI","Slovak_100_CI_AI_WS","Slovak_100_CI_AI_KS","Slovak_100_CI_AI_KS_WS","Slovak_100_CI_AS","Slovak_100_CI_AS_WS","Slovak_100_CI_AS_KS","Slovak_100_CI_AS_KS_WS","Slovak_100_CS_AI","Slovak_100_CS_AI_WS","Slovak_100_CS_AI_KS","Slovak_100_CS_AI_KS_WS","Slovak_100_CS_AS","Slovak_100_CS_AS_WS","Slovak_100_CS_AS_KS","Slovak_100_CS_AS_KS_WS","Slovenian_BIN","Slovenian_BIN2","Slovenian_CI_AI","Slovenian_CI_AI_WS","Slovenian_CI_AI_KS","Slovenian_CI_AI_KS_WS","Slovenian_CI_AS","Slovenian_CI_AS_WS","Slovenian_CI_AS_KS","Slovenian_CI_AS_KS_WS","Slovenian_CS_AI","Slovenian_CS_AI_WS","Slovenian_CS_AI_KS","Slovenian_CS_AI_KS_WS","Slovenian_CS_AS","Slovenian_CS_AS_WS","Slovenian_CS_AS_KS","Slovenian_CS_AS_KS_WS","Slovenian_100_BIN","Slovenian_100_BIN2","Slovenian_100_CI_AI","Slovenian_100_CI_AI_WS","Slovenian_100_CI_AI_KS","Slovenian_100_CI_AI_KS_WS","Slovenian_100_CI_AS","Slovenian_100_CI_AS_WS","Slovenian_100_CI_AS_KS","Slovenian_100_CI_AS_KS_WS","Slovenian_100_CS_AI","Slovenian_100_CS_AI_WS","Slovenian_100_CS_AI_KS","Slovenian_100_CS_AI_KS_WS","Slovenian_100_CS_AS","Slovenian_100_CS_AS_WS","Slovenian_100_CS_AS_KS","Slovenian_100_CS_AS_KS_WS","Syriac_90_BIN","Syriac_90_BIN2","Syriac_90_CI_AI","Syriac_90_CI_AI_WS","Syriac_90_CI_AI_KS","Syriac_90_CI_AI_KS_WS","Syriac_90_CI_AS","Syriac_90_CI_AS_WS","Syriac_90_CI_AS_KS","Syriac_90_CI_AS_KS_WS","Syriac_90_CS_AI","Syriac_90_CS_AI_WS","Syriac_90_CS_AI_KS","Syriac_90_CS_AI_KS_WS","Syriac_90_CS_AS","Syriac_90_CS_AS_WS","Syriac_90_CS_AS_KS","Syriac_90_CS_AS_KS_WS","Syriac_100_BIN","Syriac_100_BIN2","Syriac_100_CI_AI","Syriac_100_CI_AI_WS","Syriac_100_CI_AI_KS","Syriac_100_CI_AI_KS_WS","Syriac_100_CI_AS","Syriac_100_CI_AS_WS","Syriac_100_CI_AS_KS","Syriac_100_CI_AS_KS_WS","Syriac_100_CS_AI","Syriac_100_CS_AI_WS","Syriac_100_CS_AI_KS","Syriac_100_CS_AI_KS_WS","Syriac_100_CS_AS","Syriac_100_CS_AS_WS","Syriac_100_CS_AS_KS","Syriac_100_CS_AS_KS_WS","Tamazight_100_BIN","Tamazight_100_BIN2","Tamazight_100_CI_AI","Tamazight_100_CI_AI_WS","Tamazight_100_CI_AI_KS","Tamazight_100_CI_AI_KS_WS","Tamazight_100_CI_AS","Tamazight_100_CI_AS_WS","Tamazight_100_CI_AS_KS","Tamazight_100_CI_AS_KS_WS","Tamazight_100_CS_AI","Tamazight_100_CS_AI_WS","Tamazight_100_CS_AI_KS","Tamazight_100_CS_AI_KS_WS","Tamazight_100_CS_AS","Tamazight_100_CS_AS_WS","Tamazight_100_CS_AS_KS","Tamazight_100_CS_AS_KS_WS","Tatar_90_BIN","Tatar_90_BIN2","Tatar_90_CI_AI","Tatar_90_CI_AI_WS","Tatar_90_CI_AI_KS","Tatar_90_CI_AI_KS_WS","Tatar_90_CI_AS","Tatar_90_CI_AS_WS","Tatar_90_CI_AS_KS","Tatar_90_CI_AS_KS_WS","Tatar_90_CS_AI","Tatar_90_CS_AI_WS","Tatar_90_CS_AI_KS","Tatar_90_CS_AI_KS_WS","Tatar_90_CS_AS","Tatar_90_CS_AS_WS","Tatar_90_CS_AS_KS","Tatar_90_CS_AS_KS_WS","Tatar_100_BIN","Tatar_100_BIN2","Tatar_100_CI_AI","Tatar_100_CI_AI_WS","Tatar_100_CI_AI_KS","Tatar_100_CI_AI_KS_WS","Tatar_100_CI_AS","Tatar_100_CI_AS_WS","Tatar_100_CI_AS_KS","Tatar_100_CI_AS_KS_WS","Tatar_100_CS_AI","Tatar_100_CS_AI_WS","Tatar_100_CS_AI_KS","Tatar_100_CS_AI_KS_WS","Tatar_100_CS_AS","Tatar_100_CS_AS_WS","Tatar_100_CS_AS_KS","Tatar_100_CS_AS_KS_WS","Thai_BIN","Thai_BIN2","Thai_CI_AI","Thai_CI_AI_WS","Thai_CI_AI_KS","Thai_CI_AI_KS_WS","Thai_CI_AS","Thai_CI_AS_WS","Thai_CI_AS_KS","Thai_CI_AS_KS_WS","Thai_CS_AI","Thai_CS_AI_WS","Thai_CS_AI_KS","Thai_CS_AI_KS_WS","Thai_CS_AS","Thai_CS_AS_WS","Thai_CS_AS_KS","Thai_CS_AS_KS_WS","Thai_100_BIN","Thai_100_BIN2","Thai_100_CI_AI","Thai_100_CI_AI_WS","Thai_100_CI_AI_KS","Thai_100_CI_AI_KS_WS","Thai_100_CI_AS","Thai_100_CI_AS_WS","Thai_100_CI_AS_KS","Thai_100_CI_AS_KS_WS","Thai_100_CS_AI","Thai_100_CS_AI_WS","Thai_100_CS_AI_KS","Thai_100_CS_AI_KS_WS","Thai_100_CS_AS","Thai_100_CS_AS_WS","Thai_100_CS_AS_KS","Thai_100_CS_AS_KS_WS","Tibetan_100_BIN","Tibetan_100_BIN2","Tibetan_100_CI_AI","Tibetan_100_CI_AI_WS","Tibetan_100_CI_AI_KS","Tibetan_100_CI_AI_KS_WS","Tibetan_100_CI_AS","Tibetan_100_CI_AS_WS","Tibetan_100_CI_AS_KS","Tibetan_100_CI_AS_KS_WS","Tibetan_100_CS_AI","Tibetan_100_CS_AI_WS","Tibetan_100_CS_AI_KS","Tibetan_100_CS_AI_KS_WS","Tibetan_100_CS_AS","Tibetan_100_CS_AS_WS","Tibetan_100_CS_AS_KS","Tibetan_100_CS_AS_KS_WS","Traditional_Spanish_BIN","Traditional_Spanish_BIN2","Traditional_Spanish_CI_AI","Traditional_Spanish_CI_AI_WS","Traditional_Spanish_CI_AI_KS","Traditional_Spanish_CI_AI_KS_WS","Traditional_Spanish_CI_AS","Traditional_Spanish_CI_AS_WS","Traditional_Spanish_CI_AS_KS","Traditional_Spanish_CI_AS_KS_WS","Traditional_Spanish_CS_AI","Traditional_Spanish_CS_AI_WS","Traditional_Spanish_CS_AI_KS","Traditional_Spanish_CS_AI_KS_WS","Traditional_Spanish_CS_AS","Traditional_Spanish_CS_AS_WS","Traditional_Spanish_CS_AS_KS","Traditional_Spanish_CS_AS_KS_WS","Traditional_Spanish_100_BIN","Traditional_Spanish_100_BIN2","Traditional_Spanish_100_CI_AI","Traditional_Spanish_100_CI_AI_WS","Traditional_Spanish_100_CI_AI_KS","Traditional_Spanish_100_CI_AI_KS_WS","Traditional_Spanish_100_CI_AS","Traditional_Spanish_100_CI_AS_WS","Traditional_Spanish_100_CI_AS_KS","Traditional_Spanish_100_CI_AS_KS_WS","Traditional_Spanish_100_CS_AI","Traditional_Spanish_100_CS_AI_WS","Traditional_Spanish_100_CS_AI_KS","Traditional_Spanish_100_CS_AI_KS_WS","Traditional_Spanish_100_CS_AS","Traditional_Spanish_100_CS_AS_WS","Traditional_Spanish_100_CS_AS_KS","Traditional_Spanish_100_CS_AS_KS_WS","Turkish_BIN","Turkish_BIN2","Turkish_CI_AI","Turkish_CI_AI_WS","Turkish_CI_AI_KS","Turkish_CI_AI_KS_WS","Turkish_CI_AS","Turkish_CI_AS_WS","Turkish_CI_AS_KS","Turkish_CI_AS_KS_WS","Turkish_CS_AI","Turkish_CS_AI_WS","Turkish_CS_AI_KS","Turkish_CS_AI_KS_WS","Turkish_CS_AS","Turkish_CS_AS_WS","Turkish_CS_AS_KS","Turkish_CS_AS_KS_WS","Turkish_100_BIN","Turkish_100_BIN2","Turkish_100_CI_AI","Turkish_100_CI_AI_WS","Turkish_100_CI_AI_KS","Turkish_100_CI_AI_KS_WS","Turkish_100_CI_AS","Turkish_100_CI_AS_WS","Turkish_100_CI_AS_KS","Turkish_100_CI_AS_KS_WS","Turkish_100_CS_AI","Turkish_100_CS_AI_WS","Turkish_100_CS_AI_KS","Turkish_100_CS_AI_KS_WS","Turkish_100_CS_AS","Turkish_100_CS_AS_WS","Turkish_100_CS_AS_KS","Turkish_100_CS_AS_KS_WS","Turkmen_100_BIN","Turkmen_100_BIN2","Turkmen_100_CI_AI","Turkmen_100_CI_AI_WS","Turkmen_100_CI_AI_KS","Turkmen_100_CI_AI_KS_WS","Turkmen_100_CI_AS","Turkmen_100_CI_AS_WS","Turkmen_100_CI_AS_KS","Turkmen_100_CI_AS_KS_WS","Turkmen_100_CS_AI","Turkmen_100_CS_AI_WS","Turkmen_100_CS_AI_KS","Turkmen_100_CS_AI_KS_WS","Turkmen_100_CS_AS","Turkmen_100_CS_AS_WS","Turkmen_100_CS_AS_KS","Turkmen_100_CS_AS_KS_WS","Uighur_100_BIN","Uighur_100_BIN2","Uighur_100_CI_AI","Uighur_100_CI_AI_WS","Uighur_100_CI_AI_KS","Uighur_100_CI_AI_KS_WS","Uighur_100_CI_AS","Uighur_100_CI_AS_WS","Uighur_100_CI_AS_KS","Uighur_100_CI_AS_KS_WS","Uighur_100_CS_AI","Uighur_100_CS_AI_WS","Uighur_100_CS_AI_KS","Uighur_100_CS_AI_KS_WS","Uighur_100_CS_AS","Uighur_100_CS_AS_WS","Uighur_100_CS_AS_KS","Uighur_100_CS_AS_KS_WS","Ukrainian_BIN","Ukrainian_BIN2","Ukrainian_CI_AI","Ukrainian_CI_AI_WS","Ukrainian_CI_AI_KS","Ukrainian_CI_AI_KS_WS","Ukrainian_CI_AS","Ukrainian_CI_AS_WS","Ukrainian_CI_AS_KS","Ukrainian_CI_AS_KS_WS","Ukrainian_CS_AI","Ukrainian_CS_AI_WS","Ukrainian_CS_AI_KS","Ukrainian_CS_AI_KS_WS","Ukrainian_CS_AS","Ukrainian_CS_AS_WS","Ukrainian_CS_AS_KS","Ukrainian_CS_AS_KS_WS","Ukrainian_100_BIN","Ukrainian_100_BIN2","Ukrainian_100_CI_AI","Ukrainian_100_CI_AI_WS","Ukrainian_100_CI_AI_KS","Ukrainian_100_CI_AI_KS_WS","Ukrainian_100_CI_AS","Ukrainian_100_CI_AS_WS","Ukrainian_100_CI_AS_KS","Ukrainian_100_CI_AS_KS_WS","Ukrainian_100_CS_AI","Ukrainian_100_CS_AI_WS","Ukrainian_100_CS_AI_KS","Ukrainian_100_CS_AI_KS_WS","Ukrainian_100_CS_AS","Ukrainian_100_CS_AS_WS","Ukrainian_100_CS_AS_KS","Ukrainian_100_CS_AS_KS_WS","Upper_Sorbian_100_BIN","Upper_Sorbian_100_BIN2","Upper_Sorbian_100_CI_AI","Upper_Sorbian_100_CI_AI_WS","Upper_Sorbian_100_CI_AI_KS","Upper_Sorbian_100_CI_AI_KS_WS","Upper_Sorbian_100_CI_AS","Upper_Sorbian_100_CI_AS_WS","Upper_Sorbian_100_CI_AS_KS","Upper_Sorbian_100_CI_AS_KS_WS","Upper_Sorbian_100_CS_AI","Upper_Sorbian_100_CS_AI_WS","Upper_Sorbian_100_CS_AI_KS","Upper_Sorbian_100_CS_AI_KS_WS","Upper_Sorbian_100_CS_AS","Upper_Sorbian_100_CS_AS_WS","Upper_Sorbian_100_CS_AS_KS","Upper_Sorbian_100_CS_AS_KS_WS","Urdu_100_BIN","Urdu_100_BIN2","Urdu_100_CI_AI","Urdu_100_CI_AI_WS","Urdu_100_CI_AI_KS","Urdu_100_CI_AI_KS_WS","Urdu_100_CI_AS","Urdu_100_CI_AS_WS","Urdu_100_CI_AS_KS","Urdu_100_CI_AS_KS_WS","Urdu_100_CS_AI","Urdu_100_CS_AI_WS","Urdu_100_CS_AI_KS","Urdu_100_CS_AI_KS_WS","Urdu_100_CS_AS","Urdu_100_CS_AS_WS","Urdu_100_CS_AS_KS","Urdu_100_CS_AS_KS_WS","Uzbek_Latin_90_BIN","Uzbek_Latin_90_BIN2","Uzbek_Latin_90_CI_AI","Uzbek_Latin_90_CI_AI_WS","Uzbek_Latin_90_CI_AI_KS","Uzbek_Latin_90_CI_AI_KS_WS","Uzbek_Latin_90_CI_AS","Uzbek_Latin_90_CI_AS_WS","Uzbek_Latin_90_CI_AS_KS","Uzbek_Latin_90_CI_AS_KS_WS","Uzbek_Latin_90_CS_AI","Uzbek_Latin_90_CS_AI_WS","Uzbek_Latin_90_CS_AI_KS","Uzbek_Latin_90_CS_AI_KS_WS","Uzbek_Latin_90_CS_AS","Uzbek_Latin_90_CS_AS_WS","Uzbek_Latin_90_CS_AS_KS","Uzbek_Latin_90_CS_AS_KS_WS","Uzbek_Latin_100_BIN","Uzbek_Latin_100_BIN2","Uzbek_Latin_100_CI_AI","Uzbek_Latin_100_CI_AI_WS","Uzbek_Latin_100_CI_AI_KS","Uzbek_Latin_100_CI_AI_KS_WS","Uzbek_Latin_100_CI_AS","Uzbek_Latin_100_CI_AS_WS","Uzbek_Latin_100_CI_AS_KS","Uzbek_Latin_100_CI_AS_KS_WS","Uzbek_Latin_100_CS_AI","Uzbek_Latin_100_CS_AI_WS","Uzbek_Latin_100_CS_AI_KS","Uzbek_Latin_100_CS_AI_KS_WS","Uzbek_Latin_100_CS_AS","Uzbek_Latin_100_CS_AS_WS","Uzbek_Latin_100_CS_AS_KS","Uzbek_Latin_100_CS_AS_KS_WS","Vietnamese_BIN","Vietnamese_BIN2","Vietnamese_CI_AI","Vietnamese_CI_AI_WS","Vietnamese_CI_AI_KS","Vietnamese_CI_AI_KS_WS","Vietnamese_CI_AS","Vietnamese_CI_AS_WS","Vietnamese_CI_AS_KS","Vietnamese_CI_AS_KS_WS","Vietnamese_CS_AI","Vietnamese_CS_AI_WS","Vietnamese_CS_AI_KS","Vietnamese_CS_AI_KS_WS","Vietnamese_CS_AS","Vietnamese_CS_AS_WS","Vietnamese_CS_AS_KS","Vietnamese_CS_AS_KS_WS","Vietnamese_100_BIN","Vietnamese_100_BIN2","Vietnamese_100_CI_AI","Vietnamese_100_CI_AI_WS","Vietnamese_100_CI_AI_KS","Vietnamese_100_CI_AI_KS_WS","Vietnamese_100_CI_AS","Vietnamese_100_CI_AS_WS","Vietnamese_100_CI_AS_KS","Vietnamese_100_CI_AS_KS_WS","Vietnamese_100_CS_AI","Vietnamese_100_CS_AI_WS","Vietnamese_100_CS_AI_KS","Vietnamese_100_CS_AI_KS_WS","Vietnamese_100_CS_AS","Vietnamese_100_CS_AS_WS","Vietnamese_100_CS_AS_KS","Vietnamese_100_CS_AS_KS_WS","Welsh_100_BIN","Welsh_100_BIN2","Welsh_100_CI_AI","Welsh_100_CI_AI_WS","Welsh_100_CI_AI_KS","Welsh_100_CI_AI_KS_WS","Welsh_100_CI_AS","Welsh_100_CI_AS_WS","Welsh_100_CI_AS_KS","Welsh_100_CI_AS_KS_WS","Welsh_100_CS_AI","Welsh_100_CS_AI_WS","Welsh_100_CS_AI_KS","Welsh_100_CS_AI_KS_WS","Welsh_100_CS_AS","Welsh_100_CS_AS_WS","Welsh_100_CS_AS_KS","Welsh_100_CS_AS_KS_WS","Yakut_100_BIN","Yakut_100_BIN2","Yakut_100_CI_AI","Yakut_100_CI_AI_WS","Yakut_100_CI_AI_KS","Yakut_100_CI_AI_KS_WS","Yakut_100_CI_AS","Yakut_100_CI_AS_WS","Yakut_100_CI_AS_KS","Yakut_100_CI_AS_KS_WS","Yakut_100_CS_AI","Yakut_100_CS_AI_WS","Yakut_100_CS_AI_KS","Yakut_100_CS_AI_KS_WS","Yakut_100_CS_AS","Yakut_100_CS_AS_WS","Yakut_100_CS_AS_KS","Yakut_100_CS_AS_KS_WS","SQL_1xCompat_CP850_CI_AS","SQL_AltDiction_CP850_CI_AI","SQL_AltDiction_CP850_CI_AS","SQL_AltDiction_CP850_CS_AS","SQL_AltDiction_Pref_CP850_CI_AS","SQL_AltDiction2_CP1253_CS_AS","SQL_Croatian_CP1250_CI_AS","SQL_Croatian_CP1250_CS_AS","SQL_Czech_CP1250_CI_AS","SQL_Czech_CP1250_CS_AS","SQL_Danish_Pref_CP1_CI_AS","SQL_EBCDIC037_CP1_CS_AS","SQL_EBCDIC273_CP1_CS_AS","SQL_EBCDIC277_CP1_CS_AS","SQL_EBCDIC278_CP1_CS_AS","SQL_EBCDIC280_CP1_CS_AS","SQL_EBCDIC284_CP1_CS_AS","SQL_EBCDIC285_CP1_CS_AS","SQL_EBCDIC297_CP1_CS_AS","SQL_Estonian_CP1257_CI_AS","SQL_Estonian_CP1257_CS_AS","SQL_Hungarian_CP1250_CI_AS","SQL_Hungarian_CP1250_CS_AS","SQL_Icelandic_Pref_CP1_CI_AS","SQL_Latin1_General_CP1_CI_AI","SQL_Latin1_General_CP1_CI_AS","SQL_Latin1_General_CP1_CS_AS","SQL_Latin1_General_CP1250_CI_AS","SQL_Latin1_General_CP1250_CS_AS","SQL_Latin1_General_CP1251_CI_AS","SQL_Latin1_General_CP1251_CS_AS","SQL_Latin1_General_CP1253_CI_AI","SQL_Latin1_General_CP1253_CI_AS","SQL_Latin1_General_CP1253_CS_AS","SQL_Latin1_General_CP1254_CI_AS","SQL_Latin1_General_CP1254_CS_AS","SQL_Latin1_General_CP1255_CI_AS","SQL_Latin1_General_CP1255_CS_AS","SQL_Latin1_General_CP1256_CI_AS","SQL_Latin1_General_CP1256_CS_AS","SQL_Latin1_General_CP1257_CI_AS","SQL_Latin1_General_CP1257_CS_AS","SQL_Latin1_General_CP437_BIN","SQL_Latin1_General_CP437_BIN2","SQL_Latin1_General_CP437_CI_AI","SQL_Latin1_General_CP437_CI_AS","SQL_Latin1_General_CP437_CS_AS","SQL_Latin1_General_CP850_BIN","SQL_Latin1_General_CP850_BIN2","SQL_Latin1_General_CP850_CI_AI","SQL_Latin1_General_CP850_CI_AS","SQL_Latin1_General_CP850_CS_AS","SQL_Latin1_General_Pref_CP1_CI_AS","SQL_Latin1_General_Pref_CP437_CI_AS","SQL_Latin1_General_Pref_CP850_CI_AS","SQL_Latvian_CP1257_CI_AS","SQL_Latvian_CP1257_CS_AS","SQL_Lithuanian_CP1257_CI_AS","SQL_Lithuanian_CP1257_CS_AS","SQL_MixDiction_CP1253_CS_AS","SQL_Polish_CP1250_CI_AS","SQL_Polish_CP1250_CS_AS","SQL_Romanian_CP1250_CI_AS","SQL_Romanian_CP1250_CS_AS","SQL_Scandinavian_CP850_CI_AS","SQL_Scandinavian_CP850_CS_AS","SQL_Scandinavian_Pref_CP850_CI_AS","SQL_Slovak_CP1250_CI_AS","SQL_Slovak_CP1250_CS_AS","SQL_Slovenian_CP1250_CI_AS","SQL_Slovenian_CP1250_CS_AS","SQL_SwedishPhone_Pref_CP1_CI_AS","SQL_SwedishStd_Pref_CP1_CI_AS","SQL_Ukrainian_CP1251_CI_AS","SQL_Ukrainian_CP1251_CS_AS"
	$col2012_additional = "Albanian_100_CI_AI_KS_SC","Albanian_100_CI_AI_KS_WS_SC","Albanian_100_CI_AI_SC","Albanian_100_CI_AI_WS_SC","Albanian_100_CI_AS_KS_SC","Albanian_100_CI_AS_KS_WS_SC","Albanian_100_CI_AS_SC","Albanian_100_CI_AS_WS_SC","Albanian_100_CS_AI_KS_SC","Albanian_100_CS_AI_KS_WS_SC","Albanian_100_CS_AI_SC","Albanian_100_CS_AI_WS_SC","Albanian_100_CS_AS_KS_SC","Albanian_100_CS_AS_KS_WS_SC","Albanian_100_CS_AS_SC","Albanian_100_CS_AS_WS_SC","Arabic_100_CI_AI_KS_SC","Arabic_100_CI_AI_KS_WS_SC","Arabic_100_CI_AI_SC","Arabic_100_CI_AI_WS_SC","Arabic_100_CI_AS_KS_SC","Arabic_100_CI_AS_KS_WS_SC","Arabic_100_CI_AS_SC","Arabic_100_CI_AS_WS_SC","Arabic_100_CS_AI_KS_SC","Arabic_100_CS_AI_KS_WS_SC","Arabic_100_CS_AI_SC","Arabic_100_CS_AI_WS_SC","Arabic_100_CS_AS_KS_SC","Arabic_100_CS_AS_KS_WS_SC","Arabic_100_CS_AS_SC","Arabic_100_CS_AS_WS_SC","Assamese_100_CI_AI_KS_SC","Assamese_100_CI_AI_KS_WS_SC","Assamese_100_CI_AI_SC","Assamese_100_CI_AI_WS_SC","Assamese_100_CI_AS_KS_SC","Assamese_100_CI_AS_KS_WS_SC","Assamese_100_CI_AS_SC","Assamese_100_CI_AS_WS_SC","Assamese_100_CS_AI_KS_SC","Assamese_100_CS_AI_KS_WS_SC","Assamese_100_CS_AI_SC","Assamese_100_CS_AI_WS_SC","Assamese_100_CS_AS_KS_SC","Assamese_100_CS_AS_KS_WS_SC","Assamese_100_CS_AS_SC","Assamese_100_CS_AS_WS_SC","Azeri_Cyrillic_100_CI_AI_KS_SC","Azeri_Cyrillic_100_CI_AI_KS_WS_SC","Azeri_Cyrillic_100_CI_AI_SC","Azeri_Cyrillic_100_CI_AI_WS_SC","Azeri_Cyrillic_100_CI_AS_KS_SC","Azeri_Cyrillic_100_CI_AS_KS_WS_SC","Azeri_Cyrillic_100_CI_AS_SC","Azeri_Cyrillic_100_CI_AS_WS_SC","Azeri_Cyrillic_100_CS_AI_KS_SC","Azeri_Cyrillic_100_CS_AI_KS_WS_SC","Azeri_Cyrillic_100_CS_AI_SC","Azeri_Cyrillic_100_CS_AI_WS_SC","Azeri_Cyrillic_100_CS_AS_KS_SC","Azeri_Cyrillic_100_CS_AS_KS_WS_SC","Azeri_Cyrillic_100_CS_AS_SC","Azeri_Cyrillic_100_CS_AS_WS_SC","Azeri_Latin_100_CI_AI_KS_SC","Azeri_Latin_100_CI_AI_KS_WS_SC","Azeri_Latin_100_CI_AI_SC","Azeri_Latin_100_CI_AI_WS_SC","Azeri_Latin_100_CI_AS_KS_SC","Azeri_Latin_100_CI_AS_KS_WS_SC","Azeri_Latin_100_CI_AS_SC","Azeri_Latin_100_CI_AS_WS_SC","Azeri_Latin_100_CS_AI_KS_SC","Azeri_Latin_100_CS_AI_KS_WS_SC","Azeri_Latin_100_CS_AI_SC","Azeri_Latin_100_CS_AI_WS_SC","Azeri_Latin_100_CS_AS_KS_SC","Azeri_Latin_100_CS_AS_KS_WS_SC","Azeri_Latin_100_CS_AS_SC","Azeri_Latin_100_CS_AS_WS_SC","Bashkir_100_CI_AI_KS_SC","Bashkir_100_CI_AI_KS_WS_SC","Bashkir_100_CI_AI_SC","Bashkir_100_CI_AI_WS_SC","Bashkir_100_CI_AS_KS_SC","Bashkir_100_CI_AS_KS_WS_SC","Bashkir_100_CI_AS_SC","Bashkir_100_CI_AS_WS_SC","Bashkir_100_CS_AI_KS_SC","Bashkir_100_CS_AI_KS_WS_SC","Bashkir_100_CS_AI_SC","Bashkir_100_CS_AI_WS_SC","Bashkir_100_CS_AS_KS_SC","Bashkir_100_CS_AS_KS_WS_SC","Bashkir_100_CS_AS_SC","Bashkir_100_CS_AS_WS_SC","Bengali_100_CI_AI_KS_SC","Bengali_100_CI_AI_KS_WS_SC","Bengali_100_CI_AI_SC","Bengali_100_CI_AI_WS_SC","Bengali_100_CI_AS_KS_SC","Bengali_100_CI_AS_KS_WS_SC","Bengali_100_CI_AS_SC","Bengali_100_CI_AS_WS_SC","Bengali_100_CS_AI_KS_SC","Bengali_100_CS_AI_KS_WS_SC","Bengali_100_CS_AI_SC","Bengali_100_CS_AI_WS_SC","Bengali_100_CS_AS_KS_SC","Bengali_100_CS_AS_KS_WS_SC","Bengali_100_CS_AS_SC","Bengali_100_CS_AS_WS_SC","Bosnian_Cyrillic_100_CI_AI_KS_SC","Bosnian_Cyrillic_100_CI_AI_KS_WS_SC","Bosnian_Cyrillic_100_CI_AI_SC","Bosnian_Cyrillic_100_CI_AI_WS_SC","Bosnian_Cyrillic_100_CI_AS_KS_SC","Bosnian_Cyrillic_100_CI_AS_KS_WS_SC","Bosnian_Cyrillic_100_CI_AS_SC","Bosnian_Cyrillic_100_CI_AS_WS_SC","Bosnian_Cyrillic_100_CS_AI_KS_SC","Bosnian_Cyrillic_100_CS_AI_KS_WS_SC","Bosnian_Cyrillic_100_CS_AI_SC","Bosnian_Cyrillic_100_CS_AI_WS_SC","Bosnian_Cyrillic_100_CS_AS_KS_SC","Bosnian_Cyrillic_100_CS_AS_KS_WS_SC","Bosnian_Cyrillic_100_CS_AS_SC","Bosnian_Cyrillic_100_CS_AS_WS_SC","Bosnian_Latin_100_CI_AI_KS_SC","Bosnian_Latin_100_CI_AI_KS_WS_SC","Bosnian_Latin_100_CI_AI_SC","Bosnian_Latin_100_CI_AI_WS_SC","Bosnian_Latin_100_CI_AS_KS_SC","Bosnian_Latin_100_CI_AS_KS_WS_SC","Bosnian_Latin_100_CI_AS_SC","Bosnian_Latin_100_CI_AS_WS_SC","Bosnian_Latin_100_CS_AI_KS_SC","Bosnian_Latin_100_CS_AI_KS_WS_SC","Bosnian_Latin_100_CS_AI_SC","Bosnian_Latin_100_CS_AI_WS_SC","Bosnian_Latin_100_CS_AS_KS_SC","Bosnian_Latin_100_CS_AS_KS_WS_SC","Bosnian_Latin_100_CS_AS_SC","Bosnian_Latin_100_CS_AS_WS_SC","Breton_100_CI_AI_KS_SC","Breton_100_CI_AI_KS_WS_SC","Breton_100_CI_AI_SC","Breton_100_CI_AI_WS_SC","Breton_100_CI_AS_KS_SC","Breton_100_CI_AS_KS_WS_SC","Breton_100_CI_AS_SC","Breton_100_CI_AS_WS_SC","Breton_100_CS_AI_KS_SC","Breton_100_CS_AI_KS_WS_SC","Breton_100_CS_AI_SC","Breton_100_CS_AI_WS_SC","Breton_100_CS_AS_KS_SC","Breton_100_CS_AS_KS_WS_SC","Breton_100_CS_AS_SC","Breton_100_CS_AS_WS_SC","Chinese_Hong_Kong_Stroke_90_CI_AI_KS_SC","Chinese_Hong_Kong_Stroke_90_CI_AI_KS_WS_SC","Chinese_Hong_Kong_Stroke_90_CI_AI_SC","Chinese_Hong_Kong_Stroke_90_CI_AI_WS_SC","Chinese_Hong_Kong_Stroke_90_CI_AS_KS_SC","Chinese_Hong_Kong_Stroke_90_CI_AS_KS_WS_SC","Chinese_Hong_Kong_Stroke_90_CI_AS_SC","Chinese_Hong_Kong_Stroke_90_CI_AS_WS_SC","Chinese_Hong_Kong_Stroke_90_CS_AI_KS_SC","Chinese_Hong_Kong_Stroke_90_CS_AI_KS_WS_SC","Chinese_Hong_Kong_Stroke_90_CS_AI_SC","Chinese_Hong_Kong_Stroke_90_CS_AI_WS_SC","Chinese_Hong_Kong_Stroke_90_CS_AS_KS_SC","Chinese_Hong_Kong_Stroke_90_CS_AS_KS_WS_SC","Chinese_Hong_Kong_Stroke_90_CS_AS_SC","Chinese_Hong_Kong_Stroke_90_CS_AS_WS_SC","Chinese_PRC_90_CI_AI_KS_SC","Chinese_PRC_90_CI_AI_KS_WS_SC","Chinese_PRC_90_CI_AI_SC","Chinese_PRC_90_CI_AI_WS_SC","Chinese_PRC_90_CI_AS_KS_SC","Chinese_PRC_90_CI_AS_KS_WS_SC","Chinese_PRC_90_CI_AS_SC","Chinese_PRC_90_CI_AS_WS_SC","Chinese_PRC_90_CS_AI_KS_SC","Chinese_PRC_90_CS_AI_KS_WS_SC","Chinese_PRC_90_CS_AI_SC","Chinese_PRC_90_CS_AI_WS_SC","Chinese_PRC_90_CS_AS_KS_SC","Chinese_PRC_90_CS_AS_KS_WS_SC","Chinese_PRC_90_CS_AS_SC","Chinese_PRC_90_CS_AS_WS_SC","Chinese_PRC_Stroke_90_CI_AI_KS_SC","Chinese_PRC_Stroke_90_CI_AI_KS_WS_SC","Chinese_PRC_Stroke_90_CI_AI_SC","Chinese_PRC_Stroke_90_CI_AI_WS_SC","Chinese_PRC_Stroke_90_CI_AS_KS_SC","Chinese_PRC_Stroke_90_CI_AS_KS_WS_SC","Chinese_PRC_Stroke_90_CI_AS_SC","Chinese_PRC_Stroke_90_CI_AS_WS_SC","Chinese_PRC_Stroke_90_CS_AI_KS_SC","Chinese_PRC_Stroke_90_CS_AI_KS_WS_SC","Chinese_PRC_Stroke_90_CS_AI_SC","Chinese_PRC_Stroke_90_CS_AI_WS_SC","Chinese_PRC_Stroke_90_CS_AS_KS_SC","Chinese_PRC_Stroke_90_CS_AS_KS_WS_SC","Chinese_PRC_Stroke_90_CS_AS_SC","Chinese_PRC_Stroke_90_CS_AS_WS_SC","Chinese_Simplified_Pinyin_100_CI_AI_KS_SC","Chinese_Simplified_Pinyin_100_CI_AI_KS_WS_SC","Chinese_Simplified_Pinyin_100_CI_AI_SC","Chinese_Simplified_Pinyin_100_CI_AI_WS_SC","Chinese_Simplified_Pinyin_100_CI_AS_KS_SC","Chinese_Simplified_Pinyin_100_CI_AS_KS_WS_SC","Chinese_Simplified_Pinyin_100_CI_AS_SC","Chinese_Simplified_Pinyin_100_CI_AS_WS_SC","Chinese_Simplified_Pinyin_100_CS_AI_KS_SC","Chinese_Simplified_Pinyin_100_CS_AI_KS_WS_SC","Chinese_Simplified_Pinyin_100_CS_AI_SC","Chinese_Simplified_Pinyin_100_CS_AI_WS_SC","Chinese_Simplified_Pinyin_100_CS_AS_KS_SC","Chinese_Simplified_Pinyin_100_CS_AS_KS_WS_SC","Chinese_Simplified_Pinyin_100_CS_AS_SC","Chinese_Simplified_Pinyin_100_CS_AS_WS_SC","Chinese_Simplified_Stroke_Order_100_CI_AI_KS_SC","Chinese_Simplified_Stroke_Order_100_CI_AI_KS_WS_SC","Chinese_Simplified_Stroke_Order_100_CI_AI_SC","Chinese_Simplified_Stroke_Order_100_CI_AI_WS_SC","Chinese_Simplified_Stroke_Order_100_CI_AS_KS_SC","Chinese_Simplified_Stroke_Order_100_CI_AS_KS_WS_SC","Chinese_Simplified_Stroke_Order_100_CI_AS_SC","Chinese_Simplified_Stroke_Order_100_CI_AS_WS_SC","Chinese_Simplified_Stroke_Order_100_CS_AI_KS_SC","Chinese_Simplified_Stroke_Order_100_CS_AI_KS_WS_SC","Chinese_Simplified_Stroke_Order_100_CS_AI_SC","Chinese_Simplified_Stroke_Order_100_CS_AI_WS_SC","Chinese_Simplified_Stroke_Order_100_CS_AS_KS_SC","Chinese_Simplified_Stroke_Order_100_CS_AS_KS_WS_SC","Chinese_Simplified_Stroke_Order_100_CS_AS_SC","Chinese_Simplified_Stroke_Order_100_CS_AS_WS_SC","Chinese_Taiwan_Bopomofo_90_CI_AI_KS_SC","Chinese_Taiwan_Bopomofo_90_CI_AI_KS_WS_SC","Chinese_Taiwan_Bopomofo_90_CI_AI_SC","Chinese_Taiwan_Bopomofo_90_CI_AI_WS_SC","Chinese_Taiwan_Bopomofo_90_CI_AS_KS_SC","Chinese_Taiwan_Bopomofo_90_CI_AS_KS_WS_SC","Chinese_Taiwan_Bopomofo_90_CI_AS_SC","Chinese_Taiwan_Bopomofo_90_CI_AS_WS_SC","Chinese_Taiwan_Bopomofo_90_CS_AI_KS_SC","Chinese_Taiwan_Bopomofo_90_CS_AI_KS_WS_SC","Chinese_Taiwan_Bopomofo_90_CS_AI_SC","Chinese_Taiwan_Bopomofo_90_CS_AI_WS_SC","Chinese_Taiwan_Bopomofo_90_CS_AS_KS_SC","Chinese_Taiwan_Bopomofo_90_CS_AS_KS_WS_SC","Chinese_Taiwan_Bopomofo_90_CS_AS_SC","Chinese_Taiwan_Bopomofo_90_CS_AS_WS_SC","Chinese_Taiwan_Stroke_90_CI_AI_KS_SC","Chinese_Taiwan_Stroke_90_CI_AI_KS_WS_SC","Chinese_Taiwan_Stroke_90_CI_AI_SC","Chinese_Taiwan_Stroke_90_CI_AI_WS_SC","Chinese_Taiwan_Stroke_90_CI_AS_KS_SC","Chinese_Taiwan_Stroke_90_CI_AS_KS_WS_SC","Chinese_Taiwan_Stroke_90_CI_AS_SC","Chinese_Taiwan_Stroke_90_CI_AS_WS_SC","Chinese_Taiwan_Stroke_90_CS_AI_KS_SC","Chinese_Taiwan_Stroke_90_CS_AI_KS_WS_SC","Chinese_Taiwan_Stroke_90_CS_AI_SC","Chinese_Taiwan_Stroke_90_CS_AI_WS_SC","Chinese_Taiwan_Stroke_90_CS_AS_KS_SC","Chinese_Taiwan_Stroke_90_CS_AS_KS_WS_SC","Chinese_Taiwan_Stroke_90_CS_AS_SC","Chinese_Taiwan_Stroke_90_CS_AS_WS_SC","Chinese_Traditional_Bopomofo_100_CI_AI_KS_SC","Chinese_Traditional_Bopomofo_100_CI_AI_KS_WS_SC","Chinese_Traditional_Bopomofo_100_CI_AI_SC","Chinese_Traditional_Bopomofo_100_CI_AI_WS_SC","Chinese_Traditional_Bopomofo_100_CI_AS_KS_SC","Chinese_Traditional_Bopomofo_100_CI_AS_KS_WS_SC","Chinese_Traditional_Bopomofo_100_CI_AS_SC","Chinese_Traditional_Bopomofo_100_CI_AS_WS_SC","Chinese_Traditional_Bopomofo_100_CS_AI_KS_SC","Chinese_Traditional_Bopomofo_100_CS_AI_KS_WS_SC","Chinese_Traditional_Bopomofo_100_CS_AI_SC","Chinese_Traditional_Bopomofo_100_CS_AI_WS_SC","Chinese_Traditional_Bopomofo_100_CS_AS_KS_SC","Chinese_Traditional_Bopomofo_100_CS_AS_KS_WS_SC","Chinese_Traditional_Bopomofo_100_CS_AS_SC","Chinese_Traditional_Bopomofo_100_CS_AS_WS_SC","Chinese_Traditional_Pinyin_100_CI_AI_KS_SC","Chinese_Traditional_Pinyin_100_CI_AI_KS_WS_SC","Chinese_Traditional_Pinyin_100_CI_AI_SC","Chinese_Traditional_Pinyin_100_CI_AI_WS_SC","Chinese_Traditional_Pinyin_100_CI_AS_KS_SC","Chinese_Traditional_Pinyin_100_CI_AS_KS_WS_SC","Chinese_Traditional_Pinyin_100_CI_AS_SC","Chinese_Traditional_Pinyin_100_CI_AS_WS_SC","Chinese_Traditional_Pinyin_100_CS_AI_KS_SC","Chinese_Traditional_Pinyin_100_CS_AI_KS_WS_SC","Chinese_Traditional_Pinyin_100_CS_AI_SC","Chinese_Traditional_Pinyin_100_CS_AI_WS_SC","Chinese_Traditional_Pinyin_100_CS_AS_KS_SC","Chinese_Traditional_Pinyin_100_CS_AS_KS_WS_SC","Chinese_Traditional_Pinyin_100_CS_AS_SC","Chinese_Traditional_Pinyin_100_CS_AS_WS_SC","Chinese_Traditional_Stroke_Count_100_CI_AI_KS_SC","Chinese_Traditional_Stroke_Count_100_CI_AI_KS_WS_SC","Chinese_Traditional_Stroke_Count_100_CI_AI_SC","Chinese_Traditional_Stroke_Count_100_CI_AI_WS_SC","Chinese_Traditional_Stroke_Count_100_CI_AS_KS_SC","Chinese_Traditional_Stroke_Count_100_CI_AS_KS_WS_SC","Chinese_Traditional_Stroke_Count_100_CI_AS_SC","Chinese_Traditional_Stroke_Count_100_CI_AS_WS_SC","Chinese_Traditional_Stroke_Count_100_CS_AI_KS_SC","Chinese_Traditional_Stroke_Count_100_CS_AI_KS_WS_SC","Chinese_Traditional_Stroke_Count_100_CS_AI_SC","Chinese_Traditional_Stroke_Count_100_CS_AI_WS_SC","Chinese_Traditional_Stroke_Count_100_CS_AS_KS_SC","Chinese_Traditional_Stroke_Count_100_CS_AS_KS_WS_SC","Chinese_Traditional_Stroke_Count_100_CS_AS_SC","Chinese_Traditional_Stroke_Count_100_CS_AS_WS_SC","Chinese_Traditional_Stroke_Order_100_CI_AI_KS_SC","Chinese_Traditional_Stroke_Order_100_CI_AI_KS_WS_SC","Chinese_Traditional_Stroke_Order_100_CI_AI_SC","Chinese_Traditional_Stroke_Order_100_CI_AI_WS_SC","Chinese_Traditional_Stroke_Order_100_CI_AS_KS_SC","Chinese_Traditional_Stroke_Order_100_CI_AS_KS_WS_SC","Chinese_Traditional_Stroke_Order_100_CI_AS_SC","Chinese_Traditional_Stroke_Order_100_CI_AS_WS_SC","Chinese_Traditional_Stroke_Order_100_CS_AI_KS_SC","Chinese_Traditional_Stroke_Order_100_CS_AI_KS_WS_SC","Chinese_Traditional_Stroke_Order_100_CS_AI_SC","Chinese_Traditional_Stroke_Order_100_CS_AI_WS_SC","Chinese_Traditional_Stroke_Order_100_CS_AS_KS_SC","Chinese_Traditional_Stroke_Order_100_CS_AS_KS_WS_SC","Chinese_Traditional_Stroke_Order_100_CS_AS_SC","Chinese_Traditional_Stroke_Order_100_CS_AS_WS_SC","Corsican_100_CI_AI_KS_SC","Corsican_100_CI_AI_KS_WS_SC","Corsican_100_CI_AI_SC","Corsican_100_CI_AI_WS_SC","Corsican_100_CI_AS_KS_SC","Corsican_100_CI_AS_KS_WS_SC","Corsican_100_CI_AS_SC","Corsican_100_CI_AS_WS_SC","Corsican_100_CS_AI_KS_SC","Corsican_100_CS_AI_KS_WS_SC","Corsican_100_CS_AI_SC","Corsican_100_CS_AI_WS_SC","Corsican_100_CS_AS_KS_SC","Corsican_100_CS_AS_KS_WS_SC","Corsican_100_CS_AS_SC","Corsican_100_CS_AS_WS_SC","Croatian_100_CI_AI_KS_SC","Croatian_100_CI_AI_KS_WS_SC","Croatian_100_CI_AI_SC","Croatian_100_CI_AI_WS_SC","Croatian_100_CI_AS_KS_SC","Croatian_100_CI_AS_KS_WS_SC","Croatian_100_CI_AS_SC","Croatian_100_CI_AS_WS_SC","Croatian_100_CS_AI_KS_SC","Croatian_100_CS_AI_KS_WS_SC","Croatian_100_CS_AI_SC","Croatian_100_CS_AI_WS_SC","Croatian_100_CS_AS_KS_SC","Croatian_100_CS_AS_KS_WS_SC","Croatian_100_CS_AS_SC","Croatian_100_CS_AS_WS_SC","Cyrillic_General_100_CI_AI_KS_SC","Cyrillic_General_100_CI_AI_KS_WS_SC","Cyrillic_General_100_CI_AI_SC","Cyrillic_General_100_CI_AI_WS_SC","Cyrillic_General_100_CI_AS_KS_SC","Cyrillic_General_100_CI_AS_KS_WS_SC","Cyrillic_General_100_CI_AS_SC","Cyrillic_General_100_CI_AS_WS_SC","Cyrillic_General_100_CS_AI_KS_SC","Cyrillic_General_100_CS_AI_KS_WS_SC","Cyrillic_General_100_CS_AI_SC","Cyrillic_General_100_CS_AI_WS_SC","Cyrillic_General_100_CS_AS_KS_SC","Cyrillic_General_100_CS_AS_KS_WS_SC","Cyrillic_General_100_CS_AS_SC","Cyrillic_General_100_CS_AS_WS_SC","Czech_100_CI_AI_KS_SC","Czech_100_CI_AI_KS_WS_SC","Czech_100_CI_AI_SC","Czech_100_CI_AI_WS_SC","Czech_100_CI_AS_KS_SC","Czech_100_CI_AS_KS_WS_SC","Czech_100_CI_AS_SC","Czech_100_CI_AS_WS_SC","Czech_100_CS_AI_KS_SC","Czech_100_CS_AI_KS_WS_SC","Czech_100_CS_AI_SC","Czech_100_CS_AI_WS_SC","Czech_100_CS_AS_KS_SC","Czech_100_CS_AS_KS_WS_SC","Czech_100_CS_AS_SC","Czech_100_CS_AS_WS_SC","Danish_Greenlandic_100_CI_AI_KS_SC","Danish_Greenlandic_100_CI_AI_KS_WS_SC","Danish_Greenlandic_100_CI_AI_SC","Danish_Greenlandic_100_CI_AI_WS_SC","Danish_Greenlandic_100_CI_AS_KS_SC","Danish_Greenlandic_100_CI_AS_KS_WS_SC","Danish_Greenlandic_100_CI_AS_SC","Danish_Greenlandic_100_CI_AS_WS_SC","Danish_Greenlandic_100_CS_AI_KS_SC","Danish_Greenlandic_100_CS_AI_KS_WS_SC","Danish_Greenlandic_100_CS_AI_SC","Danish_Greenlandic_100_CS_AI_WS_SC","Danish_Greenlandic_100_CS_AS_KS_SC","Danish_Greenlandic_100_CS_AS_KS_WS_SC","Danish_Greenlandic_100_CS_AS_SC","Danish_Greenlandic_100_CS_AS_WS_SC","Dari_100_CI_AI_KS_SC","Dari_100_CI_AI_KS_WS_SC","Dari_100_CI_AI_SC","Dari_100_CI_AI_WS_SC","Dari_100_CI_AS_KS_SC","Dari_100_CI_AS_KS_WS_SC","Dari_100_CI_AS_SC","Dari_100_CI_AS_WS_SC","Dari_100_CS_AI_KS_SC","Dari_100_CS_AI_KS_WS_SC","Dari_100_CS_AI_SC","Dari_100_CS_AI_WS_SC","Dari_100_CS_AS_KS_SC","Dari_100_CS_AS_KS_WS_SC","Dari_100_CS_AS_SC","Dari_100_CS_AS_WS_SC","Divehi_100_CI_AI_KS_SC","Divehi_100_CI_AI_KS_WS_SC","Divehi_100_CI_AI_SC","Divehi_100_CI_AI_WS_SC","Divehi_100_CI_AS_KS_SC","Divehi_100_CI_AS_KS_WS_SC","Divehi_100_CI_AS_SC","Divehi_100_CI_AS_WS_SC","Divehi_100_CS_AI_KS_SC","Divehi_100_CS_AI_KS_WS_SC","Divehi_100_CS_AI_SC","Divehi_100_CS_AI_WS_SC","Divehi_100_CS_AS_KS_SC","Divehi_100_CS_AS_KS_WS_SC","Divehi_100_CS_AS_SC","Divehi_100_CS_AS_WS_SC","Divehi_90_CI_AI_KS_SC","Divehi_90_CI_AI_KS_WS_SC","Divehi_90_CI_AI_SC","Divehi_90_CI_AI_WS_SC","Divehi_90_CI_AS_KS_SC","Divehi_90_CI_AS_KS_WS_SC","Divehi_90_CI_AS_SC","Divehi_90_CI_AS_WS_SC","Divehi_90_CS_AI_KS_SC","Divehi_90_CS_AI_KS_WS_SC","Divehi_90_CS_AI_SC","Divehi_90_CS_AI_WS_SC","Divehi_90_CS_AS_KS_SC","Divehi_90_CS_AS_KS_WS_SC","Divehi_90_CS_AS_SC","Divehi_90_CS_AS_WS_SC","Estonian_100_CI_AI_KS_SC","Estonian_100_CI_AI_KS_WS_SC","Estonian_100_CI_AI_SC","Estonian_100_CI_AI_WS_SC","Estonian_100_CI_AS_KS_SC","Estonian_100_CI_AS_KS_WS_SC","Estonian_100_CI_AS_SC","Estonian_100_CI_AS_WS_SC","Estonian_100_CS_AI_KS_SC","Estonian_100_CS_AI_KS_WS_SC","Estonian_100_CS_AI_SC","Estonian_100_CS_AI_WS_SC","Estonian_100_CS_AS_KS_SC","Estonian_100_CS_AS_KS_WS_SC","Estonian_100_CS_AS_SC","Estonian_100_CS_AS_WS_SC","Finnish_Swedish_100_CI_AI_KS_SC","Finnish_Swedish_100_CI_AI_KS_WS_SC","Finnish_Swedish_100_CI_AI_SC","Finnish_Swedish_100_CI_AI_WS_SC","Finnish_Swedish_100_CI_AS_KS_SC","Finnish_Swedish_100_CI_AS_KS_WS_SC","Finnish_Swedish_100_CI_AS_SC","Finnish_Swedish_100_CI_AS_WS_SC","Finnish_Swedish_100_CS_AI_KS_SC","Finnish_Swedish_100_CS_AI_KS_WS_SC","Finnish_Swedish_100_CS_AI_SC","Finnish_Swedish_100_CS_AI_WS_SC","Finnish_Swedish_100_CS_AS_KS_SC","Finnish_Swedish_100_CS_AS_KS_WS_SC","Finnish_Swedish_100_CS_AS_SC","Finnish_Swedish_100_CS_AS_WS_SC","French_100_CI_AI_KS_SC","French_100_CI_AI_KS_WS_SC","French_100_CI_AI_SC","French_100_CI_AI_WS_SC","French_100_CI_AS_KS_SC","French_100_CI_AS_KS_WS_SC","French_100_CI_AS_SC","French_100_CI_AS_WS_SC","French_100_CS_AI_KS_SC","French_100_CS_AI_KS_WS_SC","French_100_CS_AI_SC","French_100_CS_AI_WS_SC","French_100_CS_AS_KS_SC","French_100_CS_AS_KS_WS_SC","French_100_CS_AS_SC","French_100_CS_AS_WS_SC","Frisian_100_CI_AI_KS_SC","Frisian_100_CI_AI_KS_WS_SC","Frisian_100_CI_AI_SC","Frisian_100_CI_AI_WS_SC","Frisian_100_CI_AS_KS_SC","Frisian_100_CI_AS_KS_WS_SC","Frisian_100_CI_AS_SC","Frisian_100_CI_AS_WS_SC","Frisian_100_CS_AI_KS_SC","Frisian_100_CS_AI_KS_WS_SC","Frisian_100_CS_AI_SC","Frisian_100_CS_AI_WS_SC","Frisian_100_CS_AS_KS_SC","Frisian_100_CS_AS_KS_WS_SC","Frisian_100_CS_AS_SC","Frisian_100_CS_AS_WS_SC","Georgian_Modern_Sort_100_CI_AI_KS_SC","Georgian_Modern_Sort_100_CI_AI_KS_WS_SC","Georgian_Modern_Sort_100_CI_AI_SC","Georgian_Modern_Sort_100_CI_AI_WS_SC","Georgian_Modern_Sort_100_CI_AS_KS_SC","Georgian_Modern_Sort_100_CI_AS_KS_WS_SC","Georgian_Modern_Sort_100_CI_AS_SC","Georgian_Modern_Sort_100_CI_AS_WS_SC","Georgian_Modern_Sort_100_CS_AI_KS_SC","Georgian_Modern_Sort_100_CS_AI_KS_WS_SC","Georgian_Modern_Sort_100_CS_AI_SC","Georgian_Modern_Sort_100_CS_AI_WS_SC","Georgian_Modern_Sort_100_CS_AS_KS_SC","Georgian_Modern_Sort_100_CS_AS_KS_WS_SC","Georgian_Modern_Sort_100_CS_AS_SC","Georgian_Modern_Sort_100_CS_AS_WS_SC","German_PhoneBook_100_CI_AI_KS_SC","German_PhoneBook_100_CI_AI_KS_WS_SC","German_PhoneBook_100_CI_AI_SC","German_PhoneBook_100_CI_AI_WS_SC","German_PhoneBook_100_CI_AS_KS_SC","German_PhoneBook_100_CI_AS_KS_WS_SC","German_PhoneBook_100_CI_AS_SC","German_PhoneBook_100_CI_AS_WS_SC","German_PhoneBook_100_CS_AI_KS_SC","German_PhoneBook_100_CS_AI_KS_WS_SC","German_PhoneBook_100_CS_AI_SC","German_PhoneBook_100_CS_AI_WS_SC","German_PhoneBook_100_CS_AS_KS_SC","German_PhoneBook_100_CS_AS_KS_WS_SC","German_PhoneBook_100_CS_AS_SC","German_PhoneBook_100_CS_AS_WS_SC","Greek_100_CI_AI_KS_SC","Greek_100_CI_AI_KS_WS_SC","Greek_100_CI_AI_SC","Greek_100_CI_AI_WS_SC","Greek_100_CI_AS_KS_SC","Greek_100_CI_AS_KS_WS_SC","Greek_100_CI_AS_SC","Greek_100_CI_AS_WS_SC","Greek_100_CS_AI_KS_SC","Greek_100_CS_AI_KS_WS_SC","Greek_100_CS_AI_SC","Greek_100_CS_AI_WS_SC","Greek_100_CS_AS_KS_SC","Greek_100_CS_AS_KS_WS_SC","Greek_100_CS_AS_SC","Greek_100_CS_AS_WS_SC","Hebrew_100_CI_AI_KS_SC","Hebrew_100_CI_AI_KS_WS_SC","Hebrew_100_CI_AI_SC","Hebrew_100_CI_AI_WS_SC","Hebrew_100_CI_AS_KS_SC","Hebrew_100_CI_AS_KS_WS_SC","Hebrew_100_CI_AS_SC","Hebrew_100_CI_AS_WS_SC","Hebrew_100_CS_AI_KS_SC","Hebrew_100_CS_AI_KS_WS_SC","Hebrew_100_CS_AI_SC","Hebrew_100_CS_AI_WS_SC","Hebrew_100_CS_AS_KS_SC","Hebrew_100_CS_AS_KS_WS_SC","Hebrew_100_CS_AS_SC","Hebrew_100_CS_AS_WS_SC","Hungarian_100_CI_AI_KS_SC","Hungarian_100_CI_AI_KS_WS_SC","Hungarian_100_CI_AI_SC","Hungarian_100_CI_AI_WS_SC","Hungarian_100_CI_AS_KS_SC","Hungarian_100_CI_AS_KS_WS_SC","Hungarian_100_CI_AS_SC","Hungarian_100_CI_AS_WS_SC","Hungarian_100_CS_AI_KS_SC","Hungarian_100_CS_AI_KS_WS_SC","Hungarian_100_CS_AI_SC","Hungarian_100_CS_AI_WS_SC","Hungarian_100_CS_AS_KS_SC","Hungarian_100_CS_AS_KS_WS_SC","Hungarian_100_CS_AS_SC","Hungarian_100_CS_AS_WS_SC","Hungarian_Technical_100_CI_AI_KS_SC","Hungarian_Technical_100_CI_AI_KS_WS_SC","Hungarian_Technical_100_CI_AI_SC","Hungarian_Technical_100_CI_AI_WS_SC","Hungarian_Technical_100_CI_AS_KS_SC","Hungarian_Technical_100_CI_AS_KS_WS_SC","Hungarian_Technical_100_CI_AS_SC","Hungarian_Technical_100_CI_AS_WS_SC","Hungarian_Technical_100_CS_AI_KS_SC","Hungarian_Technical_100_CS_AI_KS_WS_SC","Hungarian_Technical_100_CS_AI_SC","Hungarian_Technical_100_CS_AI_WS_SC","Hungarian_Technical_100_CS_AS_KS_SC","Hungarian_Technical_100_CS_AS_KS_WS_SC","Hungarian_Technical_100_CS_AS_SC","Hungarian_Technical_100_CS_AS_WS_SC","Icelandic_100_CI_AI_KS_SC","Icelandic_100_CI_AI_KS_WS_SC","Icelandic_100_CI_AI_SC","Icelandic_100_CI_AI_WS_SC","Icelandic_100_CI_AS_KS_SC","Icelandic_100_CI_AS_KS_WS_SC","Icelandic_100_CI_AS_SC","Icelandic_100_CI_AS_WS_SC","Icelandic_100_CS_AI_KS_SC","Icelandic_100_CS_AI_KS_WS_SC","Icelandic_100_CS_AI_SC","Icelandic_100_CS_AI_WS_SC","Icelandic_100_CS_AS_KS_SC","Icelandic_100_CS_AS_KS_WS_SC","Icelandic_100_CS_AS_SC","Icelandic_100_CS_AS_WS_SC","Indic_General_100_CI_AI_KS_SC","Indic_General_100_CI_AI_KS_WS_SC","Indic_General_100_CI_AI_SC","Indic_General_100_CI_AI_WS_SC","Indic_General_100_CI_AS_KS_SC","Indic_General_100_CI_AS_KS_WS_SC","Indic_General_100_CI_AS_SC","Indic_General_100_CI_AS_WS_SC","Indic_General_100_CS_AI_KS_SC","Indic_General_100_CS_AI_KS_WS_SC","Indic_General_100_CS_AI_SC","Indic_General_100_CS_AI_WS_SC","Indic_General_100_CS_AS_KS_SC","Indic_General_100_CS_AS_KS_WS_SC","Indic_General_100_CS_AS_SC","Indic_General_100_CS_AS_WS_SC","Indic_General_90_CI_AI_KS_SC","Indic_General_90_CI_AI_KS_WS_SC","Indic_General_90_CI_AI_SC","Indic_General_90_CI_AI_WS_SC","Indic_General_90_CI_AS_KS_SC","Indic_General_90_CI_AS_KS_WS_SC","Indic_General_90_CI_AS_SC","Indic_General_90_CI_AS_WS_SC","Indic_General_90_CS_AI_KS_SC","Indic_General_90_CS_AI_KS_WS_SC","Indic_General_90_CS_AI_SC","Indic_General_90_CS_AI_WS_SC","Indic_General_90_CS_AS_KS_SC","Indic_General_90_CS_AS_KS_WS_SC","Indic_General_90_CS_AS_SC","Indic_General_90_CS_AS_WS_SC","Japanese_90_CI_AI_KS_SC","Japanese_90_CI_AI_KS_WS_SC","Japanese_90_CI_AI_SC","Japanese_90_CI_AI_WS_SC","Japanese_90_CI_AS_KS_SC","Japanese_90_CI_AS_KS_WS_SC","Japanese_90_CI_AS_SC","Japanese_90_CI_AS_WS_SC","Japanese_90_CS_AI_KS_SC","Japanese_90_CS_AI_KS_WS_SC","Japanese_90_CS_AI_SC","Japanese_90_CS_AI_WS_SC","Japanese_90_CS_AS_KS_SC","Japanese_90_CS_AS_KS_WS_SC","Japanese_90_CS_AS_SC","Japanese_90_CS_AS_WS_SC","Japanese_Bushu_Kakusu_100_CI_AI_KS_SC","Japanese_Bushu_Kakusu_100_CI_AI_KS_WS_SC","Japanese_Bushu_Kakusu_100_CI_AI_SC","Japanese_Bushu_Kakusu_100_CI_AI_WS_SC","Japanese_Bushu_Kakusu_100_CI_AS_KS_SC","Japanese_Bushu_Kakusu_100_CI_AS_KS_WS_SC","Japanese_Bushu_Kakusu_100_CI_AS_SC","Japanese_Bushu_Kakusu_100_CI_AS_WS_SC","Japanese_Bushu_Kakusu_100_CS_AI_KS_SC","Japanese_Bushu_Kakusu_100_CS_AI_KS_WS_SC","Japanese_Bushu_Kakusu_100_CS_AI_SC","Japanese_Bushu_Kakusu_100_CS_AI_WS_SC","Japanese_Bushu_Kakusu_100_CS_AS_KS_SC","Japanese_Bushu_Kakusu_100_CS_AS_KS_WS_SC","Japanese_Bushu_Kakusu_100_CS_AS_SC","Japanese_Bushu_Kakusu_100_CS_AS_WS_SC","Japanese_XJIS_100_CI_AI_KS_SC","Japanese_XJIS_100_CI_AI_KS_WS_SC","Japanese_XJIS_100_CI_AI_SC","Japanese_XJIS_100_CI_AI_WS_SC","Japanese_XJIS_100_CI_AS_KS_SC","Japanese_XJIS_100_CI_AS_KS_WS_SC","Japanese_XJIS_100_CI_AS_SC","Japanese_XJIS_100_CI_AS_WS_SC","Japanese_XJIS_100_CS_AI_KS_SC","Japanese_XJIS_100_CS_AI_KS_WS_SC","Japanese_XJIS_100_CS_AI_SC","Japanese_XJIS_100_CS_AI_WS_SC","Japanese_XJIS_100_CS_AS_KS_SC","Japanese_XJIS_100_CS_AS_KS_WS_SC","Japanese_XJIS_100_CS_AS_SC","Japanese_XJIS_100_CS_AS_WS_SC","Kazakh_100_CI_AI_KS_SC","Kazakh_100_CI_AI_KS_WS_SC","Kazakh_100_CI_AI_SC","Kazakh_100_CI_AI_WS_SC","Kazakh_100_CI_AS_KS_SC","Kazakh_100_CI_AS_KS_WS_SC","Kazakh_100_CI_AS_SC","Kazakh_100_CI_AS_WS_SC","Kazakh_100_CS_AI_KS_SC","Kazakh_100_CS_AI_KS_WS_SC","Kazakh_100_CS_AI_SC","Kazakh_100_CS_AI_WS_SC","Kazakh_100_CS_AS_KS_SC","Kazakh_100_CS_AS_KS_WS_SC","Kazakh_100_CS_AS_SC","Kazakh_100_CS_AS_WS_SC","Kazakh_90_CI_AI_KS_SC","Kazakh_90_CI_AI_KS_WS_SC","Kazakh_90_CI_AI_SC","Kazakh_90_CI_AI_WS_SC","Kazakh_90_CI_AS_KS_SC","Kazakh_90_CI_AS_KS_WS_SC","Kazakh_90_CI_AS_SC","Kazakh_90_CI_AS_WS_SC","Kazakh_90_CS_AI_KS_SC","Kazakh_90_CS_AI_KS_WS_SC","Kazakh_90_CS_AI_SC","Kazakh_90_CS_AI_WS_SC","Kazakh_90_CS_AS_KS_SC","Kazakh_90_CS_AS_KS_WS_SC","Kazakh_90_CS_AS_SC","Kazakh_90_CS_AS_WS_SC","Khmer_100_CI_AI_KS_SC","Khmer_100_CI_AI_KS_WS_SC","Khmer_100_CI_AI_SC","Khmer_100_CI_AI_WS_SC","Khmer_100_CI_AS_KS_SC","Khmer_100_CI_AS_KS_WS_SC","Khmer_100_CI_AS_SC","Khmer_100_CI_AS_WS_SC","Khmer_100_CS_AI_KS_SC","Khmer_100_CS_AI_KS_WS_SC","Khmer_100_CS_AI_SC","Khmer_100_CS_AI_WS_SC","Khmer_100_CS_AS_KS_SC","Khmer_100_CS_AS_KS_WS_SC","Khmer_100_CS_AS_SC","Khmer_100_CS_AS_WS_SC","Korean_100_CI_AI_KS_SC","Korean_100_CI_AI_KS_WS_SC","Korean_100_CI_AI_SC","Korean_100_CI_AI_WS_SC","Korean_100_CI_AS_KS_SC","Korean_100_CI_AS_KS_WS_SC","Korean_100_CI_AS_SC","Korean_100_CI_AS_WS_SC","Korean_100_CS_AI_KS_SC","Korean_100_CS_AI_KS_WS_SC","Korean_100_CS_AI_SC","Korean_100_CS_AI_WS_SC","Korean_100_CS_AS_KS_SC","Korean_100_CS_AS_KS_WS_SC","Korean_100_CS_AS_SC","Korean_100_CS_AS_WS_SC","Korean_90_CI_AI_KS_SC","Korean_90_CI_AI_KS_WS_SC","Korean_90_CI_AI_SC","Korean_90_CI_AI_WS_SC","Korean_90_CI_AS_KS_SC","Korean_90_CI_AS_KS_WS_SC","Korean_90_CI_AS_SC","Korean_90_CI_AS_WS_SC","Korean_90_CS_AI_KS_SC","Korean_90_CS_AI_KS_WS_SC","Korean_90_CS_AI_SC","Korean_90_CS_AI_WS_SC","Korean_90_CS_AS_KS_SC","Korean_90_CS_AS_KS_WS_SC","Korean_90_CS_AS_SC","Korean_90_CS_AS_WS_SC","Lao_100_CI_AI_KS_SC","Lao_100_CI_AI_KS_WS_SC","Lao_100_CI_AI_SC","Lao_100_CI_AI_WS_SC","Lao_100_CI_AS_KS_SC","Lao_100_CI_AS_KS_WS_SC","Lao_100_CI_AS_SC","Lao_100_CI_AS_WS_SC","Lao_100_CS_AI_KS_SC","Lao_100_CS_AI_KS_WS_SC","Lao_100_CS_AI_SC","Lao_100_CS_AI_WS_SC","Lao_100_CS_AS_KS_SC","Lao_100_CS_AS_KS_WS_SC","Lao_100_CS_AS_SC","Lao_100_CS_AS_WS_SC","Latin1_General_100_CI_AI_KS_SC","Latin1_General_100_CI_AI_KS_WS_SC","Latin1_General_100_CI_AI_SC","Latin1_General_100_CI_AI_WS_SC","Latin1_General_100_CI_AS_KS_SC","Latin1_General_100_CI_AS_KS_WS_SC","Latin1_General_100_CI_AS_SC","Latin1_General_100_CI_AS_WS_SC","Latin1_General_100_CS_AI_KS_SC","Latin1_General_100_CS_AI_KS_WS_SC","Latin1_General_100_CS_AI_SC","Latin1_General_100_CS_AI_WS_SC","Latin1_General_100_CS_AS_KS_SC","Latin1_General_100_CS_AS_KS_WS_SC","Latin1_General_100_CS_AS_SC","Latin1_General_100_CS_AS_WS_SC","Latvian_100_CI_AI_KS_SC","Latvian_100_CI_AI_KS_WS_SC","Latvian_100_CI_AI_SC","Latvian_100_CI_AI_WS_SC","Latvian_100_CI_AS_KS_SC","Latvian_100_CI_AS_KS_WS_SC","Latvian_100_CI_AS_SC","Latvian_100_CI_AS_WS_SC","Latvian_100_CS_AI_KS_SC","Latvian_100_CS_AI_KS_WS_SC","Latvian_100_CS_AI_SC","Latvian_100_CS_AI_WS_SC","Latvian_100_CS_AS_KS_SC","Latvian_100_CS_AS_KS_WS_SC","Latvian_100_CS_AS_SC","Latvian_100_CS_AS_WS_SC","Lithuanian_100_CI_AI_KS_SC","Lithuanian_100_CI_AI_KS_WS_SC","Lithuanian_100_CI_AI_SC","Lithuanian_100_CI_AI_WS_SC","Lithuanian_100_CI_AS_KS_SC","Lithuanian_100_CI_AS_KS_WS_SC","Lithuanian_100_CI_AS_SC","Lithuanian_100_CI_AS_WS_SC","Lithuanian_100_CS_AI_KS_SC","Lithuanian_100_CS_AI_KS_WS_SC","Lithuanian_100_CS_AI_SC","Lithuanian_100_CS_AI_WS_SC","Lithuanian_100_CS_AS_KS_SC","Lithuanian_100_CS_AS_KS_WS_SC","Lithuanian_100_CS_AS_SC","Lithuanian_100_CS_AS_WS_SC","Macedonian_FYROM_100_CI_AI_KS_SC","Macedonian_FYROM_100_CI_AI_KS_WS_SC","Macedonian_FYROM_100_CI_AI_SC","Macedonian_FYROM_100_CI_AI_WS_SC","Macedonian_FYROM_100_CI_AS_KS_SC","Macedonian_FYROM_100_CI_AS_KS_WS_SC","Macedonian_FYROM_100_CI_AS_SC","Macedonian_FYROM_100_CI_AS_WS_SC","Macedonian_FYROM_100_CS_AI_KS_SC","Macedonian_FYROM_100_CS_AI_KS_WS_SC","Macedonian_FYROM_100_CS_AI_SC","Macedonian_FYROM_100_CS_AI_WS_SC","Macedonian_FYROM_100_CS_AS_KS_SC","Macedonian_FYROM_100_CS_AS_KS_WS_SC","Macedonian_FYROM_100_CS_AS_SC","Macedonian_FYROM_100_CS_AS_WS_SC","Macedonian_FYROM_90_CI_AI_KS_SC","Macedonian_FYROM_90_CI_AI_KS_WS_SC","Macedonian_FYROM_90_CI_AI_SC","Macedonian_FYROM_90_CI_AI_WS_SC","Macedonian_FYROM_90_CI_AS_KS_SC","Macedonian_FYROM_90_CI_AS_KS_WS_SC","Macedonian_FYROM_90_CI_AS_SC","Macedonian_FYROM_90_CI_AS_WS_SC","Macedonian_FYROM_90_CS_AI_KS_SC","Macedonian_FYROM_90_CS_AI_KS_WS_SC","Macedonian_FYROM_90_CS_AI_SC","Macedonian_FYROM_90_CS_AI_WS_SC","Macedonian_FYROM_90_CS_AS_KS_SC","Macedonian_FYROM_90_CS_AS_KS_WS_SC","Macedonian_FYROM_90_CS_AS_SC","Macedonian_FYROM_90_CS_AS_WS_SC","Maltese_100_CI_AI_KS_SC","Maltese_100_CI_AI_KS_WS_SC","Maltese_100_CI_AI_SC","Maltese_100_CI_AI_WS_SC","Maltese_100_CI_AS_KS_SC","Maltese_100_CI_AS_KS_WS_SC","Maltese_100_CI_AS_SC","Maltese_100_CI_AS_WS_SC","Maltese_100_CS_AI_KS_SC","Maltese_100_CS_AI_KS_WS_SC","Maltese_100_CS_AI_SC","Maltese_100_CS_AI_WS_SC","Maltese_100_CS_AS_KS_SC","Maltese_100_CS_AS_KS_WS_SC","Maltese_100_CS_AS_SC","Maltese_100_CS_AS_WS_SC","Maori_100_CI_AI_KS_SC","Maori_100_CI_AI_KS_WS_SC","Maori_100_CI_AI_SC","Maori_100_CI_AI_WS_SC","Maori_100_CI_AS_KS_SC","Maori_100_CI_AS_KS_WS_SC","Maori_100_CI_AS_SC","Maori_100_CI_AS_WS_SC","Maori_100_CS_AI_KS_SC","Maori_100_CS_AI_KS_WS_SC","Maori_100_CS_AI_SC","Maori_100_CS_AI_WS_SC","Maori_100_CS_AS_KS_SC","Maori_100_CS_AS_KS_WS_SC","Maori_100_CS_AS_SC","Maori_100_CS_AS_WS_SC","Mapudungan_100_CI_AI_KS_SC","Mapudungan_100_CI_AI_KS_WS_SC","Mapudungan_100_CI_AI_SC","Mapudungan_100_CI_AI_WS_SC","Mapudungan_100_CI_AS_KS_SC","Mapudungan_100_CI_AS_KS_WS_SC","Mapudungan_100_CI_AS_SC","Mapudungan_100_CI_AS_WS_SC","Mapudungan_100_CS_AI_KS_SC","Mapudungan_100_CS_AI_KS_WS_SC","Mapudungan_100_CS_AI_SC","Mapudungan_100_CS_AI_WS_SC","Mapudungan_100_CS_AS_KS_SC","Mapudungan_100_CS_AS_KS_WS_SC","Mapudungan_100_CS_AS_SC","Mapudungan_100_CS_AS_WS_SC","Modern_Spanish_100_CI_AI_KS_SC","Modern_Spanish_100_CI_AI_KS_WS_SC","Modern_Spanish_100_CI_AI_SC","Modern_Spanish_100_CI_AI_WS_SC","Modern_Spanish_100_CI_AS_KS_SC","Modern_Spanish_100_CI_AS_KS_WS_SC","Modern_Spanish_100_CI_AS_SC","Modern_Spanish_100_CI_AS_WS_SC","Modern_Spanish_100_CS_AI_KS_SC","Modern_Spanish_100_CS_AI_KS_WS_SC","Modern_Spanish_100_CS_AI_SC","Modern_Spanish_100_CS_AI_WS_SC","Modern_Spanish_100_CS_AS_KS_SC","Modern_Spanish_100_CS_AS_KS_WS_SC","Modern_Spanish_100_CS_AS_SC","Modern_Spanish_100_CS_AS_WS_SC","Mohawk_100_CI_AI_KS_SC","Mohawk_100_CI_AI_KS_WS_SC","Mohawk_100_CI_AI_SC","Mohawk_100_CI_AI_WS_SC","Mohawk_100_CI_AS_KS_SC","Mohawk_100_CI_AS_KS_WS_SC","Mohawk_100_CI_AS_SC","Mohawk_100_CI_AS_WS_SC","Mohawk_100_CS_AI_KS_SC","Mohawk_100_CS_AI_KS_WS_SC","Mohawk_100_CS_AI_SC","Mohawk_100_CS_AI_WS_SC","Mohawk_100_CS_AS_KS_SC","Mohawk_100_CS_AS_KS_WS_SC","Mohawk_100_CS_AS_SC","Mohawk_100_CS_AS_WS_SC","Nepali_100_CI_AI_KS_SC","Nepali_100_CI_AI_KS_WS_SC","Nepali_100_CI_AI_SC","Nepali_100_CI_AI_WS_SC","Nepali_100_CI_AS_KS_SC","Nepali_100_CI_AS_KS_WS_SC","Nepali_100_CI_AS_SC","Nepali_100_CI_AS_WS_SC","Nepali_100_CS_AI_KS_SC","Nepali_100_CS_AI_KS_WS_SC","Nepali_100_CS_AI_SC","Nepali_100_CS_AI_WS_SC","Nepali_100_CS_AS_KS_SC","Nepali_100_CS_AS_KS_WS_SC","Nepali_100_CS_AS_SC","Nepali_100_CS_AS_WS_SC","Norwegian_100_CI_AI_KS_SC","Norwegian_100_CI_AI_KS_WS_SC","Norwegian_100_CI_AI_SC","Norwegian_100_CI_AI_WS_SC","Norwegian_100_CI_AS_KS_SC","Norwegian_100_CI_AS_KS_WS_SC","Norwegian_100_CI_AS_SC","Norwegian_100_CI_AS_WS_SC","Norwegian_100_CS_AI_KS_SC","Norwegian_100_CS_AI_KS_WS_SC","Norwegian_100_CS_AI_SC","Norwegian_100_CS_AI_WS_SC","Norwegian_100_CS_AS_KS_SC","Norwegian_100_CS_AS_KS_WS_SC","Norwegian_100_CS_AS_SC","Norwegian_100_CS_AS_WS_SC","Pashto_100_CI_AI_KS_SC","Pashto_100_CI_AI_KS_WS_SC","Pashto_100_CI_AI_SC","Pashto_100_CI_AI_WS_SC","Pashto_100_CI_AS_KS_SC","Pashto_100_CI_AS_KS_WS_SC","Pashto_100_CI_AS_SC","Pashto_100_CI_AS_WS_SC","Pashto_100_CS_AI_KS_SC","Pashto_100_CS_AI_KS_WS_SC","Pashto_100_CS_AI_SC","Pashto_100_CS_AI_WS_SC","Pashto_100_CS_AS_KS_SC","Pashto_100_CS_AS_KS_WS_SC","Pashto_100_CS_AS_SC","Pashto_100_CS_AS_WS_SC","Persian_100_CI_AI_KS_SC","Persian_100_CI_AI_KS_WS_SC","Persian_100_CI_AI_SC","Persian_100_CI_AI_WS_SC","Persian_100_CI_AS_KS_SC","Persian_100_CI_AS_KS_WS_SC","Persian_100_CI_AS_SC","Persian_100_CI_AS_WS_SC","Persian_100_CS_AI_KS_SC","Persian_100_CS_AI_KS_WS_SC","Persian_100_CS_AI_SC","Persian_100_CS_AI_WS_SC","Persian_100_CS_AS_KS_SC","Persian_100_CS_AS_KS_WS_SC","Persian_100_CS_AS_SC","Persian_100_CS_AS_WS_SC","Polish_100_CI_AI_KS_SC","Polish_100_CI_AI_KS_WS_SC","Polish_100_CI_AI_SC","Polish_100_CI_AI_WS_SC","Polish_100_CI_AS_KS_SC","Polish_100_CI_AS_KS_WS_SC","Polish_100_CI_AS_SC","Polish_100_CI_AS_WS_SC","Polish_100_CS_AI_KS_SC","Polish_100_CS_AI_KS_WS_SC","Polish_100_CS_AI_SC","Polish_100_CS_AI_WS_SC","Polish_100_CS_AS_KS_SC","Polish_100_CS_AS_KS_WS_SC","Polish_100_CS_AS_SC","Polish_100_CS_AS_WS_SC","Romanian_100_CI_AI_KS_SC","Romanian_100_CI_AI_KS_WS_SC","Romanian_100_CI_AI_SC",
	"Romanian_100_CI_AI_WS_SC","Romanian_100_CI_AS_KS_SC","Romanian_100_CI_AS_KS_WS_SC","Romanian_100_CI_AS_SC","Romanian_100_CI_AS_WS_SC","Romanian_100_CS_AI_KS_SC","Romanian_100_CS_AI_KS_WS_SC","Romanian_100_CS_AI_SC","Romanian_100_CS_AI_WS_SC","Romanian_100_CS_AS_KS_SC","Romanian_100_CS_AS_KS_WS_SC","Romanian_100_CS_AS_SC","Romanian_100_CS_AS_WS_SC","Romansh_100_CI_AI_KS_SC","Romansh_100_CI_AI_KS_WS_SC","Romansh_100_CI_AI_SC","Romansh_100_CI_AI_WS_SC","Romansh_100_CI_AS_KS_SC","Romansh_100_CI_AS_KS_WS_SC","Romansh_100_CI_AS_SC","Romansh_100_CI_AS_WS_SC","Romansh_100_CS_AI_KS_SC","Romansh_100_CS_AI_KS_WS_SC","Romansh_100_CS_AI_SC","Romansh_100_CS_AI_WS_SC","Romansh_100_CS_AS_KS_SC","Romansh_100_CS_AS_KS_WS_SC","Romansh_100_CS_AS_SC","Romansh_100_CS_AS_WS_SC","Sami_Norway_100_CI_AI_KS_SC","Sami_Norway_100_CI_AI_KS_WS_SC","Sami_Norway_100_CI_AI_SC","Sami_Norway_100_CI_AI_WS_SC","Sami_Norway_100_CI_AS_KS_SC","Sami_Norway_100_CI_AS_KS_WS_SC","Sami_Norway_100_CI_AS_SC","Sami_Norway_100_CI_AS_WS_SC","Sami_Norway_100_CS_AI_KS_SC","Sami_Norway_100_CS_AI_KS_WS_SC","Sami_Norway_100_CS_AI_SC","Sami_Norway_100_CS_AI_WS_SC","Sami_Norway_100_CS_AS_KS_SC","Sami_Norway_100_CS_AS_KS_WS_SC","Sami_Norway_100_CS_AS_SC","Sami_Norway_100_CS_AS_WS_SC","Sami_Sweden_Finland_100_CI_AI_KS_SC","Sami_Sweden_Finland_100_CI_AI_KS_WS_SC","Sami_Sweden_Finland_100_CI_AI_SC","Sami_Sweden_Finland_100_CI_AI_WS_SC","Sami_Sweden_Finland_100_CI_AS_KS_SC","Sami_Sweden_Finland_100_CI_AS_KS_WS_SC","Sami_Sweden_Finland_100_CI_AS_SC","Sami_Sweden_Finland_100_CI_AS_WS_SC","Sami_Sweden_Finland_100_CS_AI_KS_SC","Sami_Sweden_Finland_100_CS_AI_KS_WS_SC","Sami_Sweden_Finland_100_CS_AI_SC","Sami_Sweden_Finland_100_CS_AI_WS_SC","Sami_Sweden_Finland_100_CS_AS_KS_SC","Sami_Sweden_Finland_100_CS_AS_KS_WS_SC","Sami_Sweden_Finland_100_CS_AS_SC","Sami_Sweden_Finland_100_CS_AS_WS_SC","Serbian_Cyrillic_100_CI_AI_KS_SC","Serbian_Cyrillic_100_CI_AI_KS_WS_SC","Serbian_Cyrillic_100_CI_AI_SC","Serbian_Cyrillic_100_CI_AI_WS_SC","Serbian_Cyrillic_100_CI_AS_KS_SC","Serbian_Cyrillic_100_CI_AS_KS_WS_SC","Serbian_Cyrillic_100_CI_AS_SC","Serbian_Cyrillic_100_CI_AS_WS_SC","Serbian_Cyrillic_100_CS_AI_KS_SC","Serbian_Cyrillic_100_CS_AI_KS_WS_SC","Serbian_Cyrillic_100_CS_AI_SC","Serbian_Cyrillic_100_CS_AI_WS_SC","Serbian_Cyrillic_100_CS_AS_KS_SC","Serbian_Cyrillic_100_CS_AS_KS_WS_SC","Serbian_Cyrillic_100_CS_AS_SC","Serbian_Cyrillic_100_CS_AS_WS_SC","Serbian_Latin_100_CI_AI_KS_SC","Serbian_Latin_100_CI_AI_KS_WS_SC","Serbian_Latin_100_CI_AI_SC","Serbian_Latin_100_CI_AI_WS_SC","Serbian_Latin_100_CI_AS_KS_SC","Serbian_Latin_100_CI_AS_KS_WS_SC","Serbian_Latin_100_CI_AS_SC","Serbian_Latin_100_CI_AS_WS_SC","Serbian_Latin_100_CS_AI_KS_SC","Serbian_Latin_100_CS_AI_KS_WS_SC","Serbian_Latin_100_CS_AI_SC","Serbian_Latin_100_CS_AI_WS_SC","Serbian_Latin_100_CS_AS_KS_SC","Serbian_Latin_100_CS_AS_KS_WS_SC","Serbian_Latin_100_CS_AS_SC","Serbian_Latin_100_CS_AS_WS_SC","Slovak_100_CI_AI_KS_SC","Slovak_100_CI_AI_KS_WS_SC","Slovak_100_CI_AI_SC","Slovak_100_CI_AI_WS_SC","Slovak_100_CI_AS_KS_SC","Slovak_100_CI_AS_KS_WS_SC","Slovak_100_CI_AS_SC","Slovak_100_CI_AS_WS_SC","Slovak_100_CS_AI_KS_SC","Slovak_100_CS_AI_KS_WS_SC","Slovak_100_CS_AI_SC","Slovak_100_CS_AI_WS_SC","Slovak_100_CS_AS_KS_SC","Slovak_100_CS_AS_KS_WS_SC","Slovak_100_CS_AS_SC","Slovak_100_CS_AS_WS_SC","Slovenian_100_CI_AI_KS_SC","Slovenian_100_CI_AI_KS_WS_SC","Slovenian_100_CI_AI_SC","Slovenian_100_CI_AI_WS_SC","Slovenian_100_CI_AS_KS_SC","Slovenian_100_CI_AS_KS_WS_SC","Slovenian_100_CI_AS_SC","Slovenian_100_CI_AS_WS_SC","Slovenian_100_CS_AI_KS_SC","Slovenian_100_CS_AI_KS_WS_SC","Slovenian_100_CS_AI_SC","Slovenian_100_CS_AI_WS_SC","Slovenian_100_CS_AS_KS_SC","Slovenian_100_CS_AS_KS_WS_SC","Slovenian_100_CS_AS_SC","Slovenian_100_CS_AS_WS_SC","Syriac_100_CI_AI_KS_SC","Syriac_100_CI_AI_KS_WS_SC","Syriac_100_CI_AI_SC","Syriac_100_CI_AI_WS_SC","Syriac_100_CI_AS_KS_SC","Syriac_100_CI_AS_KS_WS_SC","Syriac_100_CI_AS_SC","Syriac_100_CI_AS_WS_SC","Syriac_100_CS_AI_KS_SC","Syriac_100_CS_AI_KS_WS_SC","Syriac_100_CS_AI_SC","Syriac_100_CS_AI_WS_SC","Syriac_100_CS_AS_KS_SC","Syriac_100_CS_AS_KS_WS_SC","Syriac_100_CS_AS_SC","Syriac_100_CS_AS_WS_SC","Syriac_90_CI_AI_KS_SC","Syriac_90_CI_AI_KS_WS_SC","Syriac_90_CI_AI_SC","Syriac_90_CI_AI_WS_SC","Syriac_90_CI_AS_KS_SC","Syriac_90_CI_AS_KS_WS_SC","Syriac_90_CI_AS_SC","Syriac_90_CI_AS_WS_SC","Syriac_90_CS_AI_KS_SC","Syriac_90_CS_AI_KS_WS_SC","Syriac_90_CS_AI_SC","Syriac_90_CS_AI_WS_SC","Syriac_90_CS_AS_KS_SC","Syriac_90_CS_AS_KS_WS_SC","Syriac_90_CS_AS_SC","Syriac_90_CS_AS_WS_SC","Tamazight_100_CI_AI_KS_SC","Tamazight_100_CI_AI_KS_WS_SC","Tamazight_100_CI_AI_SC","Tamazight_100_CI_AI_WS_SC","Tamazight_100_CI_AS_KS_SC","Tamazight_100_CI_AS_KS_WS_SC","Tamazight_100_CI_AS_SC","Tamazight_100_CI_AS_WS_SC","Tamazight_100_CS_AI_KS_SC","Tamazight_100_CS_AI_KS_WS_SC","Tamazight_100_CS_AI_SC","Tamazight_100_CS_AI_WS_SC","Tamazight_100_CS_AS_KS_SC","Tamazight_100_CS_AS_KS_WS_SC","Tamazight_100_CS_AS_SC","Tamazight_100_CS_AS_WS_SC","Tatar_100_CI_AI_KS_SC","Tatar_100_CI_AI_KS_WS_SC","Tatar_100_CI_AI_SC","Tatar_100_CI_AI_WS_SC","Tatar_100_CI_AS_KS_SC","Tatar_100_CI_AS_KS_WS_SC","Tatar_100_CI_AS_SC","Tatar_100_CI_AS_WS_SC","Tatar_100_CS_AI_KS_SC","Tatar_100_CS_AI_KS_WS_SC","Tatar_100_CS_AI_SC","Tatar_100_CS_AI_WS_SC","Tatar_100_CS_AS_KS_SC","Tatar_100_CS_AS_KS_WS_SC","Tatar_100_CS_AS_SC","Tatar_100_CS_AS_WS_SC","Tatar_90_CI_AI_KS_SC","Tatar_90_CI_AI_KS_WS_SC","Tatar_90_CI_AI_SC","Tatar_90_CI_AI_WS_SC","Tatar_90_CI_AS_KS_SC","Tatar_90_CI_AS_KS_WS_SC","Tatar_90_CI_AS_SC","Tatar_90_CI_AS_WS_SC","Tatar_90_CS_AI_KS_SC","Tatar_90_CS_AI_KS_WS_SC","Tatar_90_CS_AI_SC","Tatar_90_CS_AI_WS_SC","Tatar_90_CS_AS_KS_SC","Tatar_90_CS_AS_KS_WS_SC","Tatar_90_CS_AS_SC","Tatar_90_CS_AS_WS_SC","Thai_100_CI_AI_KS_SC","Thai_100_CI_AI_KS_WS_SC","Thai_100_CI_AI_SC","Thai_100_CI_AI_WS_SC","Thai_100_CI_AS_KS_SC","Thai_100_CI_AS_KS_WS_SC","Thai_100_CI_AS_SC","Thai_100_CI_AS_WS_SC","Thai_100_CS_AI_KS_SC","Thai_100_CS_AI_KS_WS_SC","Thai_100_CS_AI_SC","Thai_100_CS_AI_WS_SC","Thai_100_CS_AS_KS_SC","Thai_100_CS_AS_KS_WS_SC","Thai_100_CS_AS_SC","Thai_100_CS_AS_WS_SC","Tibetan_100_CI_AI_KS_SC","Tibetan_100_CI_AI_KS_WS_SC","Tibetan_100_CI_AI_SC","Tibetan_100_CI_AI_WS_SC","Tibetan_100_CI_AS_KS_SC","Tibetan_100_CI_AS_KS_WS_SC","Tibetan_100_CI_AS_SC","Tibetan_100_CI_AS_WS_SC","Tibetan_100_CS_AI_KS_SC","Tibetan_100_CS_AI_KS_WS_SC","Tibetan_100_CS_AI_SC","Tibetan_100_CS_AI_WS_SC","Tibetan_100_CS_AS_KS_SC","Tibetan_100_CS_AS_KS_WS_SC","Tibetan_100_CS_AS_SC","Tibetan_100_CS_AS_WS_SC","Traditional_Spanish_100_CI_AI_KS_SC","Traditional_Spanish_100_CI_AI_KS_WS_SC","Traditional_Spanish_100_CI_AI_SC","Traditional_Spanish_100_CI_AI_WS_SC","Traditional_Spanish_100_CI_AS_KS_SC","Traditional_Spanish_100_CI_AS_KS_WS_SC","Traditional_Spanish_100_CI_AS_SC","Traditional_Spanish_100_CI_AS_WS_SC","Traditional_Spanish_100_CS_AI_KS_SC","Traditional_Spanish_100_CS_AI_KS_WS_SC","Traditional_Spanish_100_CS_AI_SC","Traditional_Spanish_100_CS_AI_WS_SC","Traditional_Spanish_100_CS_AS_KS_SC","Traditional_Spanish_100_CS_AS_KS_WS_SC","Traditional_Spanish_100_CS_AS_SC","Traditional_Spanish_100_CS_AS_WS_SC","Turkish_100_CI_AI_KS_SC","Turkish_100_CI_AI_KS_WS_SC","Turkish_100_CI_AI_SC","Turkish_100_CI_AI_WS_SC","Turkish_100_CI_AS_KS_SC","Turkish_100_CI_AS_KS_WS_SC","Turkish_100_CI_AS_SC","Turkish_100_CI_AS_WS_SC","Turkish_100_CS_AI_KS_SC","Turkish_100_CS_AI_KS_WS_SC","Turkish_100_CS_AI_SC","Turkish_100_CS_AI_WS_SC","Turkish_100_CS_AS_KS_SC","Turkish_100_CS_AS_KS_WS_SC","Turkish_100_CS_AS_SC","Turkish_100_CS_AS_WS_SC","Turkmen_100_CI_AI_KS_SC","Turkmen_100_CI_AI_KS_WS_SC","Turkmen_100_CI_AI_SC","Turkmen_100_CI_AI_WS_SC","Turkmen_100_CI_AS_KS_SC","Turkmen_100_CI_AS_KS_WS_SC","Turkmen_100_CI_AS_SC","Turkmen_100_CI_AS_WS_SC","Turkmen_100_CS_AI_KS_SC","Turkmen_100_CS_AI_KS_WS_SC","Turkmen_100_CS_AI_SC","Turkmen_100_CS_AI_WS_SC","Turkmen_100_CS_AS_KS_SC","Turkmen_100_CS_AS_KS_WS_SC","Turkmen_100_CS_AS_SC","Turkmen_100_CS_AS_WS_SC","Uighur_100_CI_AI_KS_SC","Uighur_100_CI_AI_KS_WS_SC","Uighur_100_CI_AI_SC","Uighur_100_CI_AI_WS_SC","Uighur_100_CI_AS_KS_SC","Uighur_100_CI_AS_KS_WS_SC","Uighur_100_CI_AS_SC","Uighur_100_CI_AS_WS_SC","Uighur_100_CS_AI_KS_SC","Uighur_100_CS_AI_KS_WS_SC","Uighur_100_CS_AI_SC","Uighur_100_CS_AI_WS_SC","Uighur_100_CS_AS_KS_SC","Uighur_100_CS_AS_KS_WS_SC","Uighur_100_CS_AS_SC","Uighur_100_CS_AS_WS_SC","Ukrainian_100_CI_AI_KS_SC","Ukrainian_100_CI_AI_KS_WS_SC","Ukrainian_100_CI_AI_SC","Ukrainian_100_CI_AI_WS_SC","Ukrainian_100_CI_AS_KS_SC","Ukrainian_100_CI_AS_KS_WS_SC","Ukrainian_100_CI_AS_SC","Ukrainian_100_CI_AS_WS_SC","Ukrainian_100_CS_AI_KS_SC","Ukrainian_100_CS_AI_KS_WS_SC","Ukrainian_100_CS_AI_SC","Ukrainian_100_CS_AI_WS_SC","Ukrainian_100_CS_AS_KS_SC","Ukrainian_100_CS_AS_KS_WS_SC","Ukrainian_100_CS_AS_SC","Ukrainian_100_CS_AS_WS_SC","Upper_Sorbian_100_CI_AI_KS_SC","Upper_Sorbian_100_CI_AI_KS_WS_SC","Upper_Sorbian_100_CI_AI_SC","Upper_Sorbian_100_CI_AI_WS_SC","Upper_Sorbian_100_CI_AS_KS_SC","Upper_Sorbian_100_CI_AS_KS_WS_SC","Upper_Sorbian_100_CI_AS_SC","Upper_Sorbian_100_CI_AS_WS_SC","Upper_Sorbian_100_CS_AI_KS_SC","Upper_Sorbian_100_CS_AI_KS_WS_SC","Upper_Sorbian_100_CS_AI_SC","Upper_Sorbian_100_CS_AI_WS_SC","Upper_Sorbian_100_CS_AS_KS_SC","Upper_Sorbian_100_CS_AS_KS_WS_SC","Upper_Sorbian_100_CS_AS_SC","Upper_Sorbian_100_CS_AS_WS_SC","Urdu_100_CI_AI_KS_SC","Urdu_100_CI_AI_KS_WS_SC","Urdu_100_CI_AI_SC","Urdu_100_CI_AI_WS_SC","Urdu_100_CI_AS_KS_SC","Urdu_100_CI_AS_KS_WS_SC","Urdu_100_CI_AS_SC","Urdu_100_CI_AS_WS_SC","Urdu_100_CS_AI_KS_SC","Urdu_100_CS_AI_KS_WS_SC","Urdu_100_CS_AI_SC","Urdu_100_CS_AI_WS_SC","Urdu_100_CS_AS_KS_SC","Urdu_100_CS_AS_KS_WS_SC","Urdu_100_CS_AS_SC","Urdu_100_CS_AS_WS_SC","Uzbek_Latin_100_CI_AI_KS_SC","Uzbek_Latin_100_CI_AI_KS_WS_SC","Uzbek_Latin_100_CI_AI_SC","Uzbek_Latin_100_CI_AI_WS_SC","Uzbek_Latin_100_CI_AS_KS_SC","Uzbek_Latin_100_CI_AS_KS_WS_SC","Uzbek_Latin_100_CI_AS_SC","Uzbek_Latin_100_CI_AS_WS_SC","Uzbek_Latin_100_CS_AI_KS_SC","Uzbek_Latin_100_CS_AI_KS_WS_SC","Uzbek_Latin_100_CS_AI_SC","Uzbek_Latin_100_CS_AI_WS_SC","Uzbek_Latin_100_CS_AS_KS_SC","Uzbek_Latin_100_CS_AS_KS_WS_SC","Uzbek_Latin_100_CS_AS_SC","Uzbek_Latin_100_CS_AS_WS_SC","Uzbek_Latin_90_CI_AI_KS_SC","Uzbek_Latin_90_CI_AI_KS_WS_SC","Uzbek_Latin_90_CI_AI_SC","Uzbek_Latin_90_CI_AI_WS_SC","Uzbek_Latin_90_CI_AS_KS_SC","Uzbek_Latin_90_CI_AS_KS_WS_SC","Uzbek_Latin_90_CI_AS_SC","Uzbek_Latin_90_CI_AS_WS_SC","Uzbek_Latin_90_CS_AI_KS_SC","Uzbek_Latin_90_CS_AI_KS_WS_SC","Uzbek_Latin_90_CS_AI_SC","Uzbek_Latin_90_CS_AI_WS_SC","Uzbek_Latin_90_CS_AS_KS_SC","Uzbek_Latin_90_CS_AS_KS_WS_SC","Uzbek_Latin_90_CS_AS_SC","Uzbek_Latin_90_CS_AS_WS_SC","Vietnamese_100_CI_AI_KS_SC","Vietnamese_100_CI_AI_KS_WS_SC","Vietnamese_100_CI_AI_SC","Vietnamese_100_CI_AI_WS_SC","Vietnamese_100_CI_AS_KS_SC","Vietnamese_100_CI_AS_KS_WS_SC","Vietnamese_100_CI_AS_SC","Vietnamese_100_CI_AS_WS_SC","Vietnamese_100_CS_AI_KS_SC","Vietnamese_100_CS_AI_KS_WS_SC","Vietnamese_100_CS_AI_SC","Vietnamese_100_CS_AI_WS_SC","Vietnamese_100_CS_AS_KS_SC","Vietnamese_100_CS_AS_KS_WS_SC","Vietnamese_100_CS_AS_SC","Vietnamese_100_CS_AS_WS_SC","Welsh_100_CI_AI_KS_SC","Welsh_100_CI_AI_KS_WS_SC","Welsh_100_CI_AI_SC","Welsh_100_CI_AI_WS_SC","Welsh_100_CI_AS_KS_SC","Welsh_100_CI_AS_KS_WS_SC","Welsh_100_CI_AS_SC","Welsh_100_CI_AS_WS_SC","Welsh_100_CS_AI_KS_SC","Welsh_100_CS_AI_KS_WS_SC","Welsh_100_CS_AI_SC","Welsh_100_CS_AI_WS_SC","Welsh_100_CS_AS_KS_SC","Welsh_100_CS_AS_KS_WS_SC","Welsh_100_CS_AS_SC","Welsh_100_CS_AS_WS_SC","Yakut_100_CI_AI_KS_SC","Yakut_100_CI_AI_KS_WS_SC","Yakut_100_CI_AI_SC","Yakut_100_CI_AI_WS_SC","Yakut_100_CI_AS_KS_SC","Yakut_100_CI_AS_KS_WS_SC","Yakut_100_CI_AS_SC","Yakut_100_CI_AS_WS_SC","Yakut_100_CS_AI_KS_SC","Yakut_100_CS_AI_KS_WS_SC","Yakut_100_CS_AI_SC","Yakut_100_CS_AI_WS_SC","Yakut_100_CS_AS_KS_SC","Yakut_100_CS_AS_KS_WS_SC","Yakut_100_CS_AS_SC","Yakut_100_CS_AS_WS_SC"
	$col2012 = $col2008 + $col2012_additional | Sort-Object
	$SQLEditions = "Standard","Enterprise","Developer"
	$SQLVersions=@{}
#--> Remove $SQLVersions.add("MSSQL 2005",$col2005)
	$SQLVersions.add("MSSQL 2008",$col2008)
	$SQLVersions.add("MSSQL 2008 R2",$col2008)
	$SQLVersions.add("MSSQL 2012",$col2012)
	GenerateForm
}

function get_port()
{
	if ($chkb_FMO.checked)
		{
		$port = 30000 + ($txt_instance.text).substring(($txt_instance.text).Length-1)
		if (!(test_port $port)){return $port}
		elseif (!(test_port $port += 10)){return $port}
		else 
			{
			$port += 10
			Do {$port +=1}
			while (test_port($port))
			}
		else {return}
		}
	else
		{
		# Create a WMI query
		if (&{Get-WmiObject -List -Namespace root\Microsoft\SqlServer\ComputerManagement10 -ea 0})
			{$WMInamespace = 'root\Microsoft\SqlServer\ComputerManagement10'}
		elseif (&{Get-WmiObject -List -Namespace root\Microsoft\SqlServer\ComputerManagement -ea 0})
			{$WMInamespace = 'root\Microsoft\SqlServer\ComputerManagement'}
		else 
			{Return 1435}
		$WQL = "SELECT PropertyStrVal FROM ServerNetworkProtocolProperty "
		$WQL += "WHERE IPAddressName = 'IPAll' AND "
		$WQL += "PropertyName = 'TcpPort' AND "
		$WQL += "ProtocolName = 'Tcp'"
		[int]$HighestPort = Get-WmiObject -query $WQL -computerName localhost -namespace $WMInamespace |
			ForEach-Object { $_.PropertyStrVal } | Sort-Object -Descending | Select-Object -First 1
		Do { $HighestPort+=1 } 
			While (test_port($HighestPort))
		Return $HighestPort
		}
}

function test_port($port)
	# test_port checks with class GetIPGlobalproperties(), if there is a listener for the determined port
	{
	$prop = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalproperties()
	if ($prop.getActiveTcpListeners() | Where-Object {$_.Port -eq $port})
		{$true}
	else
		{$false}
	}
	

function test_PendingFiles()
	# checks if the server has pending reboots and can postpone them to start an installation without reboot
	{	
	$key = "HKLM:SYSTEM\CurrentControlSet\Control\Session Manager"
	$OpenFiles = @((Get-ItemProperty $key).PendingFileRenameOperations)
	if ($OpenFiles -ne ""){$true} else {$false}
	}
	
	
function test_kid(
# checks in AD if "Don´t Expire Password" is set and KID is enabled
# uses get_username for querying user-Data from AD
[string]$kid,
[string]$userDom,
[string]$pw
) 
	{
	$userstatus=@() 		# contains Return-message
	[Bool]$User_valid=$true		# returns errorstatus
	$dom = get_dom $userdom
	$ACCOUNTDISABLE=23
	$LOCKOUT=20
	$NORMAL_ACCOUNT=15
	$DONT_EXPIRE_PASSWD=8
	$PASSWORD_EXPIRED=1
	
	$ADuserobject=find_user $kid $dom.LDAP # <<< Domain-Name in LDAP-Format
	If (!$ADuserobject)
		{$userstatus += "The user does not exist!`r`n"
		$user_valid = $false
		return $userstatus; $err}
	$uacbin=[Convert]::ToString($($ADUserobject.Properties.item("UserAccountControl")),2)
	$uacbin = $uacbin.PadLeft(25,"0")
	$uacbin.ToCharArray | Out-Null
	If ($uacbin[$ACCOUNTDISABLE] -eq "1"){$userstatus +="$KID is Disabled`r`n"; $user_valid = $false}
	If ($uacbin[$LOCKOUT] -eq "1"){$userstatus += "$KID is locked out`r`n"; $user_valid = $false}
	If ($uacbin[$DONT_EXPIRE_PASSWD] -eq "0"){$userstatus += "`"Password never expires`" for $KID is not set!`r`n"; $user_valid = $false}
	If ($uacbin[$PASSWORD_EXPIRED] -eq "1"){$userstatus += "Password for $KID is expired!`r`n"; $user_valid = $false}
	IF (($uacbin[$ACCOUNTDISABLE] -ne "1") -and ($uacbin[$LOCKOUT] -ne "1") -and ($uacbin[$DONT_EXPIRE_PASSWD] -ne "0") -and ($uacbin[$PASSWORD_EXPIRED] -ne "1"))
			{$userstatus +="ALL Options for $KID are set!`r`n"}
	$PwdValidation = check_pw $kid $pw $dom.FQDN
	If ($Error[0].FullyQualifiedErrorID -eq 'User kann nicht überprüft werden, Library fehlt')
		{$userstatus +="Password for $kid cannot be validated - Library missing`r`n";}
	elseif ($PwdValidation)
		{$userstatus +="Password for $kid is correct!`r`n"}
	else
		{$userstatus +="Password for $kid is not valid!`r`n"; $user_valid = $false}
	Return $userstatus, $User_valid
}

function check_pw($username,$password,$userdomain)
	{
	$AcctMgmt = [Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.AccountManagement")
	If (!$AcctMgmt)
		{
		$Error.Clear()
		$ErrorActionPreference = "silentlycontinue"
		throw "User kann nicht überprüft werden, Library fehlt"
		$ErrorActionPreference = "continue"
		Return
		}
	$ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
	$pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($ct, $userdomain)
	Return $pc.ValidateCredentials($username, $password)
	}

# Reads user-account from AD.
Function Get_User($username)
	{
	$Searcher=New-Object directoryServices.DirectorySearcher([ADSI]"$domLDAP")
	$Searcher.filter ="(&(objectClass=user)(sAMAccountName=$username))"
	$Searcher.findall()
	}

Function Find_User($username,[string]$userDom)
	{
	Write-Debug "find dom $userdom"
	Write-Debug "find user $username"
	$Searcher=New-Object directoryServices.DirectorySearcher([ADSI]"$userdom")
	$Searcher.filter ="(&(objectClass=user)(sAMAccountName=$username))"
	$Searcher.findall()
	}

Function Get_Dom([string]$Dom)
	{
	$domstring=@{}
	$forest = [System.DirectoryServices.ActiveDirectory.Forest]::getCurrentForest()
	$Domain = $forest.domains | Where-Object {$_.name -like "$Dom*"}
	if ($domain)
		{
		$domstring["LDAP"] = "LDAP://" + ($domain.getDirectoryEntry()).distinguishedName # beide Werte mit Return zurückgeben
		$domstring["FQDN"] = $Domain.name
		}
	else
		{
		$Domain = $forest.GetAllTrustRelationships() | ForEach-Object {$_.TrustedDomainInformation} | Where-Object {$_.NetBiosName -eq "$Dom"}
		$domstring["FQDN"] = $Domain.DnsName
		$domLDAP = $domstring.FQDN.Split(".") | ForEach-Object {"DC="+$_}
		$domstring["LDAP"] = "LDAP://" + [System.String]::Join(",",$domLDAP)
		}
	return $domstring
	}

function ApplyConfig([string]$configfile)
	# Function reads the Configuration-File and applies the values if valid
	{
	$ValidCheckBoxValues = "true","false"
	[xml]$config = Get-Content $configfile
	if ($ValidCheckBoxValues -contains $config.Configuration.Settings.FMOEnabled)
		{$chkb_FMO.checked = [System.Convert]::ToBoolean($config.Configuration.Settings.FMOEnabled)}
	else {$txt_infobox += "Configurationfile invalid or empty for FMO`r`n"}
	if ($ValidCheckBoxValues -contains $config.Configuration.Settings.SPEnabled)
		{$chkb_SP.checked = [System.Convert]::ToBoolean($config.Configuration.Settings.SPEnabled)}
	else {$txt_infobox += "Configurationfile invalid or empty for SP`r`n"}
	if ($ValidCheckBoxValues -contains $config.Configuration.Settings.CUEnabled)
		{$chkb_CU.checked = [System.Convert]::ToBoolean($config.Configuration.Settings.CUEnabled)}
	else {$txt_infobox += "Configurationfile invalid or empty for CU`r`n"}
	if ($ValidCheckBoxValues -contains $config.Configuration.Settings.AgentEnabled)
		{
		$chkb_AgtAsREAcct.checked = !([System.Convert]::ToBoolean($config.Configuration.Settings.AgentEnabled))
		$gb_AgentService.enabled = $false
		}
	else {$txt_infobox += "Configurationfile invalid or empty for AgentEnabled`r`n"}
	if ($SQLVersions.ContainsKey($config.Configuration.Settings.DefaultVersion))
		{$cb_version.selectedItem = $config.Configuration.Settings.DefaultVersion} 
	else {$txt_infobox += "Configurationfile invalid or empty for Version`r`n"}
	if ($SQLEditions -contains $config.Configuration.Settings.DefaultEdition)
		{$cb_edition.SelectedItem = $config.Configuration.Settings.DefaultEdition} 
	else {$txt_infobox += "Configurationfile invalid or empty for Edition`r`n"}
	If ($SQLVersions[$cb_version.selectedItem] -contains $config.Configuration.Settings.Defaultcollation)
		{$cb_collation.selectedItem = $config.Configuration.Settings.Defaultcollation}
	else {$txt_infobox += "Configurationfile invalid or empty for Collation`r`n"}
	}
	
Function test_int($val)
{
	[int]$return = 0
	return [System.Int32]::TryParse($val,[ref]$return)
}

#endregion

#Generated Form Function
function GenerateForm {
########################################################################
# Code Generated By: SAPIEN Technologies PrimalForms (Community Edition) v1.0.8.0
# Generated On: 19.07.2012 19:13
# Generated By: H20594
########################################################################

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects
$frm_autoInst = New-Object System.Windows.Forms.Form
$gb_Reportingservice = New-Object System.Windows.Forms.GroupBox
$chkb_RSasNetworkService = New-Object System.Windows.Forms.CheckBox
$txt_Pwd_Rs = New-Object System.Windows.Forms.TextBox
$txt_Fkid_Rs = New-Object System.Windows.Forms.TextBox
$txt_dom_RS = New-Object System.Windows.Forms.TextBox
$lbl_Pwd_ReportingService = New-Object System.Windows.Forms.Label
$lbl_DomFkid_ReportingService = New-Object System.Windows.Forms.Label
$gb_Analysisservice = New-Object System.Windows.Forms.GroupBox
$chkb_ASasSystemService = New-Object System.Windows.Forms.CheckBox
$txt_Pwd_As = New-Object System.Windows.Forms.TextBox
$txt_Fkid_AS = New-Object System.Windows.Forms.TextBox
$txt_dom_As = New-Object System.Windows.Forms.TextBox
$lbl_Pwd_AnalysisService = New-Object System.Windows.Forms.Label
$lbl_DomFkid_AnalysisServices = New-Object System.Windows.Forms.Label
$gp_basicInformation = New-Object System.Windows.Forms.GroupBox
$cb_collation = New-Object System.Windows.Forms.ComboBox
$cb_edition = New-Object System.Windows.Forms.ComboBox
$cb_version = New-Object System.Windows.Forms.ComboBox
$txt_Instance = New-Object System.Windows.Forms.TextBox
##default instance
$chkb_STD = New-Object System.Windows.Forms.CheckBox
$lbl_Collation = New-Object System.Windows.Forms.Label
$lbl_Instance = New-Object System.Windows.Forms.Label
$chkb_FMO = New-Object System.Windows.Forms.CheckBox
$lbl_Port = New-Object System.Windows.Forms.Label
$lbl_Version = New-Object System.Windows.Forms.Label
$lbl_edition = New-Object System.Windows.Forms.Label
$txt_Port = New-Object System.Windows.Forms.TextBox
$lbl_InstanceLetter = New-Object System.Windows.Forms.Label
$txt_ConfigFilePath = New-Object System.Windows.Forms.TextBox
$btn_ConfigFilePath = New-Object System.Windows.Forms.Button
$groupBox1 = New-Object System.Windows.Forms.GroupBox
$chkb_SP = New-Object System.Windows.Forms.CheckBox
$chkb_CU = New-Object System.Windows.Forms.CheckBox
$gb_Agentservice = New-Object System.Windows.Forms.GroupBox
$lbl_Pwd_Agent = New-Object System.Windows.Forms.Label
$lbl_DomFkid_Agent = New-Object System.Windows.Forms.Label
$txt_Pwd_agent = New-Object System.Windows.Forms.TextBox
$txt_Fkid_Agent = New-Object System.Windows.Forms.TextBox
$txt_Dom_Agent = New-Object System.Windows.Forms.TextBox
$gb_Sqlservice = New-Object System.Windows.Forms.GroupBox
$chkb_RsAsReAcct = New-Object System.Windows.Forms.CheckBox
$chkb_ASasREAcct = New-Object System.Windows.Forms.CheckBox
$chkb_AgtAsReAcct = New-Object System.Windows.Forms.CheckBox
$txt_dom = New-Object System.Windows.Forms.TextBox
$lbl_DomFkid = New-Object System.Windows.Forms.Label
$lbl_Pwd = New-Object System.Windows.Forms.Label
$txt_Pwd = New-Object System.Windows.Forms.TextBox
$txt_Fkid = New-Object System.Windows.Forms.TextBox
$txt_infobox = New-Object System.Windows.Forms.TextBox
$btn_unlock = New-Object System.Windows.Forms.Button
$gb_binaries = New-Object System.Windows.Forms.GroupBox
$cb_bin = New-Object System.Windows.Forms.ComboBox
$btn_verify = New-Object System.Windows.Forms.Button
$btn_reset = New-Object System.Windows.Forms.Button
$btn_create = New-Object System.Windows.Forms.Button
$gb_UserDB = New-Object System.Windows.Forms.GroupBox
$cb_UserDbLog = New-Object System.Windows.Forms.ComboBox
$lbl_UserDBLog = New-Object System.Windows.Forms.Label
$cb_UserDBData = New-Object System.Windows.Forms.ComboBox
$lbl_userDBData = New-Object System.Windows.Forms.Label
$gb_tempDb = New-Object System.Windows.Forms.GroupBox
$cb_TempDBLog = New-Object System.Windows.Forms.ComboBox
$cb_TempDBData = New-Object System.Windows.Forms.ComboBox
$lbl_TempDBLog = New-Object System.Windows.Forms.Label
$lbl_TempDBData = New-Object System.Windows.Forms.Label
$gb_systemDBs = New-Object System.Windows.Forms.GroupBox
$cb_sysDBLog = New-Object System.Windows.Forms.ComboBox
$lbl_sysDBdata = New-Object System.Windows.Forms.Label
$lbl_sysDBLog = New-Object System.Windows.Forms.Label
$cb_sysDBdata = New-Object System.Windows.Forms.ComboBox
$gb_Components = New-Object System.Windows.Forms.GroupBox
$chkB_RS = New-Object System.Windows.Forms.CheckBox
$chkB_AS = New-Object System.Windows.Forms.CheckBox
$chkb_FTS = New-Object System.Windows.Forms.CheckBox
$chkb_SSIS = New-Object System.Windows.Forms.CheckBox
$chkB_MgmtStudio = New-Object System.Windows.Forms.CheckBox
$chkb_RelationalEngine = New-Object System.Windows.Forms.CheckBox
$openFileDialog1 = New-Object System.Windows.Forms.OpenFileDialog
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.
$LoadForm= 
	{
	$drives = New-Object System.Collections.ArrayList
	Get-WmiObject Win32_LogicalDisk | Where-Object {($_.DriveType -eq 3) -and ($_.DeviceID -ne "P:")} | foreach {$drives.Add(($_.DeviceID).remove(1))}
	if ( ( $drives.Count -gt 1 ) -and ( $drives.Contains( "C" ) ) )
		{ $drives.Remove( "C" ) }
	
	$btn_create.visible=$false
	$btn_unlock.visible=$false


	$cb_bin.items.addRange( $drives ) | Out-Null
	if ($drives -contains "D")
		{$cb_bin.selectedItem = "D"}
	$cb_collation.items.addRange($col2012)
	$cb_collation.SelectedItem = "SQL_Latin1_General_CP1_CI_AS"
	$cb_edition.items.AddRange($SQLEditions)
	$cb_edition.SelectedItem = "Standard"

	
	$cb_sysDBdata.items.addRange( $drives ) | Out-Null
	$cb_sysDBLog.items.addRange($drives) | Out-Null
	$cb_TempDBdata.items.addRange($drives) | Out-Null
	$cb_TempDBLog.items.addRange($drives) | Out-Null
	$cb_UserDBData.items.addRange($drives) | Out-Null
	$cb_UserDBLog.items.addRange($drives) | Out-Null
	$cb_version.SelectedItem = "MSSQL 2012"
	$sqlVersions.Keys | sort-object | foreach-object {$cb_version.items.AddRange($_)}
	
	$chkb_AgtAsREAcct.checked = $true
	$chkb_CU.checked = $false
	$chkb_FMO.checked = $false
	$chkb_STD.checked = $false
	$chkb_SP.checked = $true

	$gb_Agentservice.enabled = $false
	$gb_ReportingService.enabled = $false
	$gb_AnalysisService.enabled = $false
	
	$lbl_instanceLetter.Text = "S"
	
	$txt_dom.Text = $dom
	$txt_dom_Agent.Text = $dom
	$txt_dom_Rs.Text = $dom
	$txt_dom_As.Text = $dom
	$txt_port.enabled = $false
	
	if (test_pendingfiles)
		{$txt_infobox.ForeColor = "Red"
		$txt_infobox.text += "Pending reboots are preventing Setup. Click 'Pending Reboot Reset' to postpone the reboot.`r`n"
		$btn_unlock.visible = $true}
	
	if (Test-Path "$mypath\scripts\$ConfigFile")
		{
		ApplyConfig( "$mypath\scripts\$configfile" )
		$txt_ConfigFilePath.text = "$mypath\scripts\$ConfigFile"
		}
	else {$txt_infobox.text += "No config-file found. Default-settings will be applied`r`n"}
	}


#region Eventhandler

$handler_btn_ConfigFilePath_OnClick= 
	{
	$result = $openFileDialog1.ShowDialog()
	If ($result -eq 'OK')
		{ $txt_ConfigFilePath.text =$openFileDialog1.Filename }
	}

$handler_btn_RebootReset_OnClick= 
	# Save Registry Key "sessionManager\PendingFileRenameOperations" so that SQL-Server can resume Installation
	# without reset
	{
	$key = "HKLM:SYSTEM\CurrentControlSet\Control\Session Manager"
	$OpenFiles = ( ( Get-ItemProperty $key ).PendingFileRenameOperations )
	$Openfiles_PP = ( (Get-ItemProperty $key ).PendingFileRenameOperations_PP )
	if ( ( $Opfenfiles_PP -ne "" ) )
		{
		$Openfiles_PP += $OpenFiles_PP + $Openfiles
		Set-ItemProperty -Path $key -name PendingFileRenameOperations_PP -value $OpenFiles_PP
		Set-ItemProperty -Path $key -name PendingFileRenameOperations -value ""
		}
	else 
		{
		Rename-ItemProperty -Path $key -Name PendingFileRenameOperations -NewName PendingFileRenameOperations_PP `
		 -ErrorAction SilentlyContinue -ErrorVariable ERR
		}
	if ( $Err )
		{
		$txt_infobox.ForeColor = "Red"
		$txt_infobox.text += "An Error occured! Could not rename PendingFileRenameOperations!`r`n"
		}
	else
		{
		$btn_unlock.visible = $false
		$txt_infobox.ForeColor = "Green"
		$txt_infobox.text += "Reboot is postponed`r`n"
		}
	}
	
$handler_btn_resetForm_OnClick= 
	{
	$cb_collation.items.clear()
	$cb_collation.items.addRange($col2008)
	$cb_collation.SelectedItem = "SQL_Latin1_General_CP1_CI_AS"
	$cb_bin.items.clear()
	$cb_sysDBdata.items.clear()
	$cb_sysDBLog.items.clear()
	$cb_TempDBdata.items.clear()
	$cb_TempDBLog.items.clear()
	$cb_UserDBData.items.clear()
	$cb_UserDBLog.items.clear()
		
	$cb_bin.items.addRange($drives) | Out-Null
	$cb_sysDBdata.items.addRange($drives) | Out-Null
	$cb_sysDBLog.items.addRange($drives) | Out-Null
	$cb_TempDBdata.items.addRange($drives) | Out-Null
	$cb_TempDBLog.items.addRange($drives) | Out-Null
	$cb_UserDBData.items.addRange($drives) | Out-Null
	$cb_UserDBLog.items.addRange($drives) | Out-Null
	
	if ($drives -contains "D"){$cb_bin.selectedItem = "D"}
	else {$cb_bin.selectedItem = ""
		  $cb_bin.Text = ""}
	$cb_sysDBdata.SelectedItem = ""
	$cb_sysDBdata.Text = ""
	$cb_sysDBLog.SelectedItem = ""
	$cb_sysDBLog.Text = ""
	$cb_TempDBdata.SelectedItem = ""
	$cb_TempDBdata.Text = ""
	$cb_TempDBLog.SelectedItem = ""
	$cb_TempDBLog.Text = ""
	$cb_UserDBData.SelectedItem = ""
	$cb_UserDBData.Text = ""
	$cb_UserDBLog.SelectedItem = ""
	$cb_UserDBLog.Text = ""

	$cb_version.items.clear()
	$cb_version.items.AddRange($SQLVersions.Keys)
	$cb_version.SelectedItem = "MSSQL 2012"
	$cb_edition.items.clear()
	$cb_edition.items.AddRange($SQLEditions)
	$cb_edition.SelectedItem = "Standard"
	if ($drives -contains "D"){$cb_bin.selectedItem = "D"}
	$chkb_RelationalEngine.checked = $true
	$chkb_mgmtStudio.checked = $true
	$chkb_SSIS.checked = $false
	$chkb_AS.checked = $false
	$chkb_RS.checked = $false
	$chkb_FTS.checked = $false
	$lbl_instanceLetter.Text = "S"
	$txt_dom.Text = $dom
	$txt_FKID.Text = ""
	$txt_Pwd.Text = ""
	$txt_Instance.Text=""
	$chkb_STD.checked = $false
	}
	
$handler_btn_Start_onClick= 
	#Checks validity of input and starts configuration.ps1 
	{
	If ((!$chkb_RelationalEngine.checked -and !$chkB_MgmtStudio.checked -and !$chkb_SSIS.checked -and !$chkB_AS.checked -and !$chkB_RS.checked))
		{$txt_infobox.text += "Please chose the Components to install`r`n"}
# 	elseif (!$txt_Instance.text -and !$chkB_STD.checked )
# 		{$txt_infobox.text += "Please enter an instance-name`r`n"}
	elseif ((!$chkb_STD.checked) -and (!$txt_Instance.text))
		{$txt_infobox.text += "0Please enter an instance-name or select default`r`n"}
	elseif (($chkb_STD.checked) -and ($txt_Instance.text -ne "MSSQLSERVER"))
		{$txt_infobox.text += "1Please enter an instance-name or select default`r`n"}

	elseif ((!$chkb_STD.checked) -and (!(test_int $(($txt_instance.text).substring(($txt_instance.text).Length-1)))))
		{$txt_infobox.text += "Please verify instance-name`r`n"	}
	
	
	elseif (!$txt_dom.text)
		{$txt_infobox.text += "Please enter a MSSQL-Service domain`r`n"}
	elseif (!$txt_Fkid.text)
		{$txt_infobox.text += "Please enter a MSSQL-Service KID`r`n"}
	elseif (!$txt_Pwd.text)
		{$txt_infobox.text += "Please enter a MSSQL-Service password`r`n"}
	elseif ((!$chkb_ASasREAccount.checked) -and (!$txt_dom_agent))
		{$txt_infobox.text += "Please enter a MSSQL-Agent Domain`r`n"}
	elseif ((!$chkb_ASasREAccount.checked) -and (!$txt_Fkid_agent))
		{$txt_infobox.text += "Please enter a MSSQL-Agent KID`r`n"}
	elseif ((!$chkb_ASasREAccount.checked) -and (!$txt_Pwd_agent))
		{$txt_infobox.text += "Please enter a MSSQL-Agent password`r`n"}
	elseif (!$cb_version.selectedItem)
		{$txt_infobox.text += "Please chose a version`r`n"}
	elseif (!$cb_edition.selectedItem)
		{$txt_infobox.text += "Please chose an edition`r`n"}
	elseif (!$cb_collation.selectedItem)
		{$txt_infobox.text += "Please chose a collation`r`n"}
	elseif (!$cb_bin.selectedItem -and !$cb_sysDBdata.selectedItem -and !$cb_sysDBLog.selectedItem -and !$cb_TempDBData.selectedItem `
		-and !$cb_TempDBLog.selectedItem -and !$cb_userDBData.selectedItem -and !$cb_userDbLog.selectedItem)
		{$txt_infobox.text += "Please chose all drive-letters`r`n"}
	else 
		# if all fields are set correctly, test create_ini.ps1-path start script
		{
		$command = ".\Scripts\create_ini.ps1 -SQLEngine `$$($chkb_RelationalEngine.checked) -Tools `$$($chkB_MgmtStudio.checked) -MSIS `$$($chkb_SSIS.checked) -MSAS `$$($chkB_AS.checked) -MSRS `$$($chkB_RS.checked) -PCU `$$($chkB_SP.checked) -CU `$$($chkB_CU.checked) -InstanceName $($txt_Instance.Text) -TcpPort $($txt_Port.Text) -SQLServiceDOM $($txt_dom.text) -ServiceUser $($txt_Fkid.text) -ServiceUserPW '$($txt_Pwd.text)' -MSSQLVersion `"$($cb_version.selectedItem)`" -MSSQLEdition $($cb_edition.selectedItem) -Collation $($cb_collation.selectedItem) -BinDrive $($cb_bin.selectedItem) -sysDBDataDrive $($cb_sysDBdata.selectedItem) -sysDBLogDrive $($cb_sysDBLog.selectedItem) -TempDBDataDrive $($cb_TempDBData.selectedItem) -TempDBLogDrive $($cb_TempDBLog.selectedItem) -UserDBDataDrive $($cb_userDBData.selectedItem) -UserDBLogDrive $($cb_userDbLog.selectedItem)"
		if (!$chkb_AgtAsREAcct.checked){$command += " -AgentDom $($txt_dom_Agent.text) -AgentUser $($txt_Fkid_Agent.text) -AgentUserPW '$($txt_Pwd_Agent.text)'"}
		if ($chkb_FMO.checked){$command += " -FMO" }
		if ($chkb_STD.checked){$command += " -STD" }
		if (Test-Path "$mypath\Scripts\create_ini.ps1")
			{
			$Error.Clear()
			$ReturnFromCreateIni = Invoke-Expression $command -ErrorAction Continue
			If ($Error)
				{$txt_infobox.text += "Error: $Error[0]"}
			else 
				{
				$txt_infobox.text += $ReturnFromCreateIni.SetupScript + " was created!`r`n"
				If ( $ReturnFromCreateIni.AdminAccounts )
					{
					$txt_infobox.text += "These Accounts were added to sysadmin-group:`r`n" `
					+ ($ReturnFromCreateIni.AdminAccounts | ForEach-Object {$_ + "`r`n"})
					}
				if ( $ReturnFromCreateIni.NonExistingAccounts )
					{
					$txt_infobox.text += "Invalid Accounts from Configuration-File:`r`n" + $ReturnFromCreateIni.NotExistingAccounts + "`r`n"
					}
				}
			}
		else
			{
			$txt_infobox.text += "Error! Create_ini.ps1 cannot be found - this file is mandatory!`r`n"
			}
		}
	}

$handler_btn_verify_OnClick= 
	{
	If ( ( !$chkb_RelationalEngine.checked -and !$chkB_MgmtStudio.checked -and !$chkb_SSIS.checked -and !$chkB_AS.checked -and !$chkB_RS.checked ) )
		{$txt_infobox.text += "Please chose the Components to install`r`n"}
# 	elseif ( !$txt_Instance.text )
# 		{$txt_infobox.text += "Please enter an instance-name`r`n"}

	elseif ((!$chkb_STD.checked) -and (!$txt_Instance.text))
		{$txt_infobox.text += "Please enter an instance-name or select default`r`n"}
	elseif (($chkb_STD.checked) -and ($txt_Instance.text -ne "MSSQLSERVER"))
		{$txt_infobox.text += "Please enter an instance-name or select default`r`n"}

	elseif ((!$chkb_STD.checked) -and (!(test_int $(($txt_instance.text).substring(($txt_instance.text).Length-1)))) )
		{$txt_infobox.text += "Please verify instance-name`r`n"	}
		
		
	elseif (!$txt_dom.text)
		{$txt_infobox.text += "Please enter a MSSQL-Service domain`r`n"}
	elseif (!$txt_Fkid.text)
		{$txt_infobox.text += "Please enter a MSSQL-Service KID`r`n"}
	elseif (!$txt_Pwd.text)
		{$txt_infobox.text += "Please enter a MSSQL-Service password`r`n"}
	elseif ((!$chkb_ASasREAccount.checked) -and (!$txt_dom_agent))
		{$txt_infobox.text += "Please enter a MSSQL-Agent Domain`r`n"}
	elseif ((!$chkb_ASasREAccount.checked) -and (!$txt_Fkid_agent))
		{$txt_infobox.text += "Please enter a MSSQL-Agent KID`r`n"}
	elseif ((!$chkb_ASasREAccount.checked) -and (!$txt_Pwd_agent))
		{$txt_infobox.text += "Please enter a MSSQL-Agent password`r`n"}
	elseif (!$cb_version.selectedItem)
		{$txt_infobox.text += "Please chose a version`r`n"}
	elseif (!$cb_edition.selectedItem)
		{$txt_infobox.text += "Please chose an edition`r`n"}
	elseif (!$cb_collation.selectedItem)
		{$txt_infobox.text += "Please chose a collation`r`n"}
	elseif (!$cb_bin.selectedItem -and !$cb_sysDBdata.selectedItem -and !$cb_sysDBLog.selectedItem -and !$cb_TempDBData.selectedItem `
		-and !$cb_TempDBLog.selectedItem -and !$cb_userDBData.selectedItem -and !$cb_userDbLog.selectedItem)
		{$txt_infobox.text += "Please chose all drive-letters`r`n"}
	else
		{
		if ($txt_Pwd.text){$txt_Pwd.text.Replace("'","''")}
		if ($txt_Pwd_Agent.text){$txt_Pwd_Agent.text.Replace("'","''")}
		if ($txt_Pwd_Rs.text){$txt_Pwd_RS.text.Replace("'","''")}
		if ($txt_Pwd_As.text){$txt_Pwd_Rs.text.Replace("'","''")}
		$txt_Port.text = Get_port
		$txt_Port.enabled = $true
#		$command = "-SQLEngine `$$($chkb_RelationalEngine.checked) -Tools `$$($chkB_MgmtStudio.checked) -MSIS `$$($chkb_SSIS.checked) -MSAS `$$($chkB_AS.checked) -MSRS `$$($chkB_RS.checked) -PCU `$$($chkB_SP.checked) -CU `$$($chkB_CU.checked) -InstanceName $($txt_Instance.Text) -TcpPort $($txt_Port.Text) -SQLServiceDOM $($txt_dom.text) -ServiceUser $($txt_Fkid.text) -ServiceUserPW '$($txt_Pwd.text)' -MSSQLVersion `"$($cb_version.selectedItem)`" -MSSQLEdition $($cb_edition.selectedItem) -Collation $($cb_collation.selectedItem) -BinDrive $($cb_bin.selectedItem) -sysDBDataDrive $($cb_sysDBdata.selectedItem) -sysDBLogDrive $($cb_sysDBLog.selectedItem) -TempDBDataDrive $($cb_TempDBData.selectedItem) -TempDBLogDrive $($cb_TempDBLog.selectedItem) -UserDBDataDrive $($cb_userDBData.selectedItem) -UserDBLogDrive $($cb_userDbLog.selectedItem)"
#		if (!$chkb_ASasREAccount.checked){$command += " -AgentDom $($txt_dom_Agent.text) -AgentUser $($txt_Fkid_Agent.text) -AgentUserPW '$($txt_Pwd_Agent.text)'"}
#		if ($chkb_FMO.checked){$command += " -FMO"}
		$UserValidationError = $false
		if ($chkb_RelationalEngine.checked)
			{
			$KID_valid = test_kid $txt_FKID.text $txt_dom.text $txt_pwd.text
			if ($Kid_valid[-1])
				{$txt_infobox.ForeColor="Green"}
			else 
				{
				$txt_infobox.foreColor="Red"
				$UserValidationError = $true
				}
			$txt_infobox.text += $kid_valid[-2]
			}
		
		if ($chkb_RelationalEngine.checked -and !$chkb_AgtAsREAcct.checked)
			{
			$KID_valid = test_kid $txt_FKID_Agent.text $txt_dom_Agent.text $txt_pwd_Agent.text
			if ($Kid_valid[-1])
				{$txt_infobox.ForeColor="Green"}
			else 
				{
				$txt_infobox.foreColor="Red"
				$UserValidationError = $true
				}
			$txt_infobox.text += $kid_valid[-2]
			}
		
		if ( $chkB_RS.checked -and !$chkb_RSasNetworkService.checked -and !$chkb_RsAsReAcct.checked ) 
			{
			$Kid_Valid = test_kid $txt_Fkid_RS.text $txt_Dom_RS.text $txt_Pwd_RS.text
			if ($Kid_valid[-1])
				{$txt_infobox.ForeColor="Green"}
			else 
				{
				$txt_infobox.foreColor="Red"
				$UserValidationError = $true
				}
			$txt_infobox.text += $kid_valid[-2]
			}
		
		if ( $chkB_AS.checked -and !$chkb_ASasREAccount.checked -and !$chkb_ASasSystemService.checked )
			{
			$Kid_Valid = test_kid $txt_Fkid_As.text $txt_Dom_As.text $txt_Pwd_As.text
			if ($Kid_valid[-1])
				{$txt_infobox.ForeColor="Green"}
			else 
				{
				$txt_infobox.foreColor="Red"
				$UserValidationError = $true
				}
			$txt_infobox.text += $kid_valid[-2]
			}

		if (!$userValidationError)
			{
			$btn_create.visible = $true
			}
		else 
			{
			$btn_create.visible = $false
			} # change to visible only if KIDs are OK
		}
	}
	
$handler_cb_bin_SelectionChangeCommited= 
{
#TODO: Place custom script here
}

$handler_cb_collation_SelectionChangeCommitted= 
{
#TODO: Place custom script here
}

$handler_cb_edition_SelectionChangeCommitted= 
{
#TODO: Place custom script here
}

$handler_cb_sysDBdata_SelectionChangeCommitted= 
	{
	$cb_sysDBLog.selectedItem = $cb_sysDBdata.SelectedItem 
	}

$handler_cb_TempDBdata_SelectionChangeCommited= 
	{
	$cb_TempDBLog.SelectedItem = $cb_TempDBdata.SelectedItem
	}	
	

$handler_cb_UserDBData_SelectionChangeCommited= 
	{
	$cb_UserDBLog.SelectedItem = $cb_UserDBData.SelectedItem
	}

$handler_cb_version_SelectionChangeCommitted= 
	# reconfigures GUI when SQL-Version is changed
	{
	if ( $cb_version.selectedItem -eq "MSSQL 2005" )
		{
		$cb_collation.items.clear()
		$cb_collation.items.addRange($col2005)
		$cb_collation.selectedItem="Latin1_General_CI_AS"
		$chkb_SP.checked = $false
		$chkb_SP.Enabled = $false
		$chkb_CU.checked = $false
		$chkb_CU.Enabled = $false
		}
	elseif ( $cb_version.selectedItem -like "MSSQL 2008*" )
		{
		$cb_collation.items.clear()
		$cb_collation.items.addRange($col2008)
		$cb_collation.SelectedItem = "SQL_Latin1_General_CP1_CI_AS"
		$chkb_SP.checked = $true
		$chkb_SP.Enabled = $true
		$chkb_CU.checked = $false
		$chkb_CU.Enabled = $true
		}
	elseif ( $cb_version.selectedItem -eq "MSSQL 2012" )
		{
		$cb_collation.items.clear()
		$cb_collation.items.addRange($col2012)
		$cb_collation.SelectedItem = "SQL_Latin1_General_CP1_CI_AS"
		$chkb_SP.checked = $true
		$chkb_SP.Enabled = $true
		$chkb_CU.checked = $false
		$chkb_CU.Enabled = $false
		}
}

$handler_chkb_AgtAsReAcct_checkedChanged= 
	{
	if ($gb_AgentService.enabled)
		{$gb_AgentService.enabled = $false}
	else
		{$gb_AgentService.enabled = $true}
	}

$handler_chkb_ASasREAccount_checkedChanged= 
	{
	if ( $chkb_AsAsReAcct.checked -eq $true )
		{ 
		$gb_Analysisservice.enabled = $false 
		}
	else 
		{ $gb_Analysisservice.enabled = $true }
	}

$handler_chkb_ASasSystemService_checkedChanged= 
	{
	if ( $chkb_AsAsSystemService.checked -eq $true )
		{ 
		$txt_dom_AS.enabled = $false
		$txt_Fkid_As.enabled = $false
		$txt_Pwd_As.enabled = $false
		}
	else 
		{ 
		$txt_dom_AS.enabled = $true
		$txt_Fkid_As.enabled = $true
		$txt_Pwd_As.enabled = $true
		}
	}

$handler_chkB_AS_checkedChanged= 
	{
	if (($chkB_RelationalEngine.checked -eq $true))
		{$lbl_InstanceLetter.Text = "S"}
	elseif (($chkB_RS.checked -eq $true) -and (!$chkb_RelationalEngine.checked) -and (!$chkB_AS.checked))
		{$lbl_InstanceLetter.Text = "R"}
	elseif (($chkB_AS.checked -eq $true) -and (!$chkb_RelationalEngine.checked) -and (!$chkB_RS.checked))
		{$lbl_InstanceLetter.Text = "A"}
	elseif (( $chkB_AS.checked ) -and ( $chkB_RS.checked ) -and ( !$chkb_RelationalEngine.checked ))
		{
		$gb_Sqlservice.enabled = $false
		$lbl_InstanceLetter.Text = "A/R"
		}
	elseif ( !$chkB_RelationalEngine.checked )
		{
		$gb_Sqlservice.enabled = $false
		}
	
	if (( $chkB_AS.checked -eq $true ) -and ( $chkb_AsAsReAcct.checked -eq $false) )
		{
		$gb_Analysisservice.enabled = $true
		$chkb_ASAsREAcct.enabled = $true
		}
	elseif (( $chkB_AS.checked -eq $true ) -and ( $chkb_AsAsReAcct.checked -eq $true) )
		{
		$gb_Analysisservice.enabled = $false
		$chkb_ASAsREAcct.enabled = $true
		}
	else
		{
		$gb_Analysisservice.enabled = $false
		$chkb_ASAsREAcct.enabled = $false
		}
	}

$handler_chkb_CU_CheckedChanged= 
	# not implemented
	{
	Write-Debug "CU checked"
	}
	
$handler_chkb_FMO_checkedChanged= 
	{
	if (!$chkb_FMO.checked)
		{
		$chkb_AgtAsREAcct.checked = $true
		$gb_Agentservice.enabled = $false
		}
	else 
		{	
		$chkb_AgtAsREAcct.checked = $false
		$gb_Agentservice.enabled = $true
		}
	}
	
$handler_chkb_STD_checkedChanged= 
	{
	if (!$chkb_STD.checked)
		{
		$txt_Instance.enabled = $true
		$txt_Instance.Text = ""
		}
	else 
		{	
		$txt_Instance.enabled = $false
		$txt_Instance.Text = "MSSQLSERVER"
		}
	}	
	
$handler_chkB_FTS_checkedChanged= 
{
#TODO: Place custom script here
}

$handler_chkB_IS_checkedChanged= 
{
#TODO: Place custom script here
}

$handler_chkB_MgmtStudio_checkedChanged= 
{
#TODO: Place custom script here
}

$handler_chkB_RelationalEngine_checkedChanged= 
	{
	if ( $chkB_RelationalEngine.checked )
		{
		$gb_Sqlservice.enabled = $true
		$lbl_InstanceLetter.Text = "S"
		}
	elseif (( $chkB_RS.checked ) -and ( !$chkb_RelationalEngine.checked ) -and ( !$chkB_AS.checked ))
		{
		$gb_Sqlservice.enabled = $false
		$lbl_InstanceLetter.Text = "R"
		}
	elseif (( $chkB_AS.checked ) -and ( !$chkb_RelationalEngine.checked ) -and ( !$chkB_RS.checked ))
		{
		$gb_Sqlservice.enabled = $false
		$lbl_InstanceLetter.Text = "A"
		}
	elseif (( $chkB_AS.checked ) -and ( $chkB_RS.checked ) -and ( !$chkb_RelationalEngine.checked ))
		{
		$gb_Sqlservice.enabled = $false
		$lbl_InstanceLetter.Text = "A/R"
		}
	elseif ( !$chkB_RelationalEngine.checked )
		{
		$gb_Sqlservice.enabled = $false
		}
	}

$handler_chkb_RSasNetworkService_checkedChanged= 
	{
	if ( $chkb_RsAsNetworkService.checked -eq $true )
		{ 
		$txt_dom_RS.enabled = $false
		$txt_Fkid_Rs.enabled = $false
		$txt_Pwd_Rs.enabled = $false
		}
	else 
		{ 
		$txt_dom_RS.enabled = $true
		$txt_Fkid_Rs.enabled = $true
		$txt_Pwd_Rs.enabled = $true
		}
	}

$handler_chkb_RsAsReAcct_checkedChanged= 
	{
	if ( $chkb_RsAsReAcct.checked -eq $true )
		{ 
		$gb_Reportingservice.enabled = $false 
		}
	else 
		{ $gb_Reportingservice.enabled = $true }
	}

$handler_chkB_RS_checkedChanged= 
	{
	if (($chkB_RelationalEngine.checked -eq $true))
		{$lbl_InstanceLetter.Text = "S"}
	elseif (($chkB_RS.checked -eq $true) -and (!$chkb_RelationalEngine.checked) -and (!$chkB_AS.checked))
		{$lbl_InstanceLetter.Text = "R"}
	elseif (($chkB_AS.checked -eq $true) -and (!$chkb_RelationalEngine.checked) -and (!$chkB_RS.checked))
		{$lbl_InstanceLetter.Text = "A"}
	elseif (( $chkB_AS.checked ) -and ( $chkB_RS.checked ) -and ( !$chkb_RelationalEngine.checked ))
		{
		$gb_Sqlservice.enabled = $false
		$lbl_InstanceLetter.Text = "A/R"
		}
	elseif ( !$chkB_RelationalEngine.checked )
		{
		$gb_Sqlservice.enabled = $false
		}
	
	if (( $chkB_RS.checked -eq $true ) -and ( $chkb_RsAsReAcct.checked -eq $false) )
		{
		$gb_Reportingservice.enabled = $true
		$chkb_RSAsREAcct.enabled = $true
		}
	elseif (( $chkB_RS.checked -eq $true ) -and ( $chkb_RsAsReAcct.checked -eq $true) )
		{
		$gb_Reportingservice.enabled = $false
		$chkb_RSAsREAcct.enabled = $true
		}
	else
		{
		$gb_Reportingservice.enabled = $false
		$chkb_RSAsREAcct.enabled = $false
		}
	}

$handler_chkb_SP_CheckedChanged= 
{
#TODO: Place custom script here
}

#endregion

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$frm_autoInst.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 118
$System_Drawing_Point.Y = -13
$frm_autoInst.Location = $System_Drawing_Point
$frm_autoInst.Text = "SQL-Server Automated Installation V3.1"
$frm_autoInst.Name = "frm_autoInst"
$frm_autoInst.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 643
$System_Drawing_Size.Height = 595
$frm_autoInst.ClientSize = $System_Drawing_Size
$frm_autoInst.add_Load($LoadForm)

$gb_Reportingservice.Name = "gb_Reportingservice"

$gb_Reportingservice.Text = "MSSQL Reporting-Services Account"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 295
$System_Drawing_Size.Height = 91
$gb_Reportingservice.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 314
$System_Drawing_Point.Y = 259
$gb_Reportingservice.Location = $System_Drawing_Point
$gb_Reportingservice.TabStop = $False
$gb_Reportingservice.TabIndex = 7
$gb_Reportingservice.DataBindings.DefaultDataSourceUpdateMode = 0
$gb_Reportingservice.Enabled = $False

$frm_autoInst.Controls.Add($gb_Reportingservice)

$chkb_RSasNetworkService.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 160
$System_Drawing_Size.Height = 24
$chkb_RSasNetworkService.Size = $System_Drawing_Size
$chkb_RSasNetworkService.TabIndex = 5
$chkb_RSasNetworkService.Text = "Run as Network Service"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 94
$System_Drawing_Point.Y = 63
$chkb_RSasNetworkService.Location = $System_Drawing_Point
$chkb_RSasNetworkService.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_RSasNetworkService.Name = "chkb_RSasNetworkService"

$chkb_RSasNetworkService.add_CheckStateChanged($handler_chkb_RSasNetworkService_checkedChanged)

$gb_Reportingservice.Controls.Add($chkb_RSasNetworkService)

$txt_Pwd_Rs.PasswordChar = '*'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 193
$System_Drawing_Size.Height = 20
$txt_Pwd_Rs.Size = $System_Drawing_Size
$txt_Pwd_Rs.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Pwd_Rs.Name = "txt_Pwd_Rs"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 94
$System_Drawing_Point.Y = 43
$txt_Pwd_Rs.Location = $System_Drawing_Point
$txt_Pwd_Rs.TabIndex = 4

$gb_Reportingservice.Controls.Add($txt_Pwd_Rs)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 135
$System_Drawing_Size.Height = 20
$txt_Fkid_Rs.Size = $System_Drawing_Size
$txt_Fkid_Rs.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Fkid_Rs.Name = "txt_Fkid_Rs"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 152
$System_Drawing_Point.Y = 21
$txt_Fkid_Rs.Location = $System_Drawing_Point
$txt_Fkid_Rs.TabIndex = 3

$gb_Reportingservice.Controls.Add($txt_Fkid_Rs)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 58
$System_Drawing_Size.Height = 20
$txt_dom_RS.Size = $System_Drawing_Size
$txt_dom_RS.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_dom_RS.Name = "txt_dom_RS"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 94
$System_Drawing_Point.Y = 21
$txt_dom_RS.Location = $System_Drawing_Point
$txt_dom_RS.TabIndex = 2

$gb_Reportingservice.Controls.Add($txt_dom_RS)

$lbl_Pwd_ReportingService.TabIndex = 1
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 76
$System_Drawing_Size.Height = 23
$lbl_Pwd_ReportingService.Size = $System_Drawing_Size
$lbl_Pwd_ReportingService.Text = "FKID-Pwd:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 46
$lbl_Pwd_ReportingService.Location = $System_Drawing_Point
$lbl_Pwd_ReportingService.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_Pwd_ReportingService.Name = "lbl_Pwd_ReportingService"

$gb_Reportingservice.Controls.Add($lbl_Pwd_ReportingService)

$lbl_DomFkid_ReportingService.TabIndex = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 76
$System_Drawing_Size.Height = 23
$lbl_DomFkid_ReportingService.Size = $System_Drawing_Size
$lbl_DomFkid_ReportingService.Text = "Domain\FKID:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 24
$lbl_DomFkid_ReportingService.Location = $System_Drawing_Point
$lbl_DomFkid_ReportingService.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_DomFkid_ReportingService.Name = "lbl_DomFkid_ReportingService"

$gb_Reportingservice.Controls.Add($lbl_DomFkid_ReportingService)


$gb_Analysisservice.Name = "gb_Analysisservice"

$gb_Analysisservice.Text = "MSSQL Analysis-Services Account"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 295
$System_Drawing_Size.Height = 90
$gb_Analysisservice.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 314
$System_Drawing_Point.Y = 362
$gb_Analysisservice.Location = $System_Drawing_Point
$gb_Analysisservice.TabStop = $False
$gb_Analysisservice.TabIndex = 8
$gb_Analysisservice.DataBindings.DefaultDataSourceUpdateMode = 0
$gb_Analysisservice.Enabled = $False

$frm_autoInst.Controls.Add($gb_Analysisservice)

$chkb_ASasSystemService.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 159
$System_Drawing_Size.Height = 24
$chkb_ASasSystemService.Size = $System_Drawing_Size
$chkb_ASasSystemService.TabIndex = 5
$chkb_ASasSystemService.Text = "Run as Local System"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 60
$chkb_ASasSystemService.Location = $System_Drawing_Point
$chkb_ASasSystemService.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_ASasSystemService.Name = "chkb_ASasSystemService"

$chkb_ASasSystemService.add_CheckStateChanged($handler_chkb_ASasSystemService_checkedChanged)

$gb_Analysisservice.Controls.Add($chkb_ASasSystemService)

$txt_Pwd_As.PasswordChar = '*'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 193
$System_Drawing_Size.Height = 20
$txt_Pwd_As.Size = $System_Drawing_Size
$txt_Pwd_As.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Pwd_As.Name = "txt_Pwd_As"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 41
$txt_Pwd_As.Location = $System_Drawing_Point
$txt_Pwd_As.TabIndex = 4

$gb_Analysisservice.Controls.Add($txt_Pwd_As)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 135
$System_Drawing_Size.Height = 20
$txt_Fkid_AS.Size = $System_Drawing_Size
$txt_Fkid_AS.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Fkid_AS.Name = "txt_Fkid_AS"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 153
$System_Drawing_Point.Y = 19
$txt_Fkid_AS.Location = $System_Drawing_Point
$txt_Fkid_AS.TabIndex = 3

$gb_Analysisservice.Controls.Add($txt_Fkid_AS)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 58
$System_Drawing_Size.Height = 20
$txt_dom_As.Size = $System_Drawing_Size
$txt_dom_As.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_dom_As.Name = "txt_dom_As"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 19
$txt_dom_As.Location = $System_Drawing_Point
$txt_dom_As.TabIndex = 2

$gb_Analysisservice.Controls.Add($txt_dom_As)

$lbl_Pwd_AnalysisService.TabIndex = 1
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 23
$lbl_Pwd_AnalysisService.Size = $System_Drawing_Size
$lbl_Pwd_AnalysisService.Text = "FKID-Pwd:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 8
$System_Drawing_Point.Y = 45
$lbl_Pwd_AnalysisService.Location = $System_Drawing_Point
$lbl_Pwd_AnalysisService.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_Pwd_AnalysisService.Name = "lbl_Pwd_AnalysisService"

$gb_Analysisservice.Controls.Add($lbl_Pwd_AnalysisService)

$lbl_DomFkid_AnalysisServices.TabIndex = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 23
$lbl_DomFkid_AnalysisServices.Size = $System_Drawing_Size
$lbl_DomFkid_AnalysisServices.Text = "Domain\FKID:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 8
$System_Drawing_Point.Y = 22
$lbl_DomFkid_AnalysisServices.Location = $System_Drawing_Point
$lbl_DomFkid_AnalysisServices.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_DomFkid_AnalysisServices.Name = "lbl_DomFkid_AnalysisServices"

$gb_Analysisservice.Controls.Add($lbl_DomFkid_AnalysisServices)


$gp_basicInformation.Name = "gp_basicInformation"

$gp_basicInformation.Text = "Basic Information"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 294
$System_Drawing_Size.Height = 142
$gp_basicInformation.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 111
$gp_basicInformation.Location = $System_Drawing_Point
$gp_basicInformation.TabStop = $False
$gp_basicInformation.TabIndex = 4
$gp_basicInformation.DataBindings.DefaultDataSourceUpdateMode = 0

$frm_autoInst.Controls.Add($gp_basicInformation)
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 193
$System_Drawing_Size.Height = 21
$cb_collation.Size = $System_Drawing_Size
$cb_collation.DataBindings.DefaultDataSourceUpdateMode = 0
$cb_collation.Name = "cb_collation"
$cb_collation.Items.Add("1")|Out-Null
$cb_collation.Items.Add("2")|Out-Null
$cb_collation.Items.Add("3")|Out-Null
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 94
$System_Drawing_Point.Y = 113
$cb_collation.Location = $System_Drawing_Point
$cb_collation.TabIndex = 9
$cb_collation.add_Click($handler_cb_collation_SelectionChangeCommitted)

$gp_basicInformation.Controls.Add($cb_collation)

$cb_edition.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 193
$System_Drawing_Size.Height = 21
$cb_edition.Size = $System_Drawing_Size
$cb_edition.DataBindings.DefaultDataSourceUpdateMode = 0
$cb_edition.Name = "cb_edition"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 94
$System_Drawing_Point.Y = 88
$cb_edition.Location = $System_Drawing_Point
$cb_edition.TabIndex = 8
$cb_edition.add_Click($handler_cb_edition_SelectionChangeCommitted)

$gp_basicInformation.Controls.Add($cb_edition)

$cb_version.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 193
$System_Drawing_Size.Height = 21
$cb_version.Size = $System_Drawing_Size
$cb_version.DataBindings.DefaultDataSourceUpdateMode = 0
$cb_version.Name = "cb_version"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 94
$System_Drawing_Point.Y = 64
$cb_version.Location = $System_Drawing_Point
$cb_version.TabIndex = 7
$cb_version.add_SelectionChangeCommitted($handler_cb_version_SelectionChangeCommitted)

$gp_basicInformation.Controls.Add($cb_version)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 48
$System_Drawing_Size.Height = 20
$txt_Instance.Size = $System_Drawing_Size
$txt_Instance.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Instance.Name = "txt_Instance"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 123
$System_Drawing_Point.Y = 19
$txt_Instance.Location = $System_Drawing_Point
$txt_Instance.TabIndex = 2

$gp_basicInformation.Controls.Add($txt_Instance)

$lbl_Collation.TabIndex = 32
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 61
$System_Drawing_Size.Height = 16
$lbl_Collation.Size = $System_Drawing_Size
$lbl_Collation.Text = "Collation:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 116
$lbl_Collation.Location = $System_Drawing_Point
$lbl_Collation.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_Collation.Name = "lbl_Collation"

$gp_basicInformation.Controls.Add($lbl_Collation)

$lbl_Instance.TabIndex = 1
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 78
$System_Drawing_Size.Height = 23
$lbl_Instance.Size = $System_Drawing_Size
$lbl_Instance.Text = "Instancename:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 22
$lbl_Instance.Location = $System_Drawing_Point
$lbl_Instance.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_Instance.Name = "lbl_Instance"

$gp_basicInformation.Controls.Add($lbl_Instance)


$chkb_FMO.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 51
$System_Drawing_Size.Height = 24
$chkb_FMO.Size = $System_Drawing_Size
$chkb_FMO.TabIndex = 39
$chkb_FMO.Text = "FMO"
$chkb_FMO.Checked = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 234
$System_Drawing_Point.Y = 17
$chkb_FMO.Location = $System_Drawing_Point
$chkb_FMO.CheckState = 1
$chkb_FMO.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_FMO.Name = "chkb_FMO"

$chkb_FMO.Enabled = $true
$chkb_FMO.add_CheckedChanged($handler_chkb_FMO_checkedChanged)

$gp_basicInformation.Controls.Add($chkb_STD)

$chkb_STD.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 24
$chkb_STD.Size = $System_Drawing_Size
$chkb_STD.TabIndex = 40
$chkb_STD.Text = "Default"
$chkb_STD.Checked = $false
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 17
$chkb_STD.Location = $System_Drawing_Point
$chkb_STD.CheckState = 1
$chkb_STD.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_STD.Name = "chkb_STD"

$chkb_STD.Enabled = $true
$chkb_STD.add_CheckedChanged($handler_chkb_STD_checkedChanged)

$gp_basicInformation.Controls.Add($chkb_STD)



$lbl_Port.TabIndex = 27
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 78
$System_Drawing_Size.Height = 14
$lbl_Port.Size = $System_Drawing_Size
$lbl_Port.Text = "Tcp Port:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 44
$lbl_Port.Location = $System_Drawing_Point
$lbl_Port.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_Port.Name = "lbl_Port"

$gp_basicInformation.Controls.Add($lbl_Port)

$lbl_Version.TabIndex = 30
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 98
$System_Drawing_Size.Height = 23
$lbl_Version.Size = $System_Drawing_Size
$lbl_Version.Text = "MSSQL-Version:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 67
$lbl_Version.Location = $System_Drawing_Point
$lbl_Version.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_Version.Name = "lbl_Version"

$gp_basicInformation.Controls.Add($lbl_Version)

$lbl_edition.TabIndex = 31
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 86
$System_Drawing_Size.Height = 19
$lbl_edition.Size = $System_Drawing_Size
$lbl_edition.Text = "MSSQL-Edition:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 91
$lbl_edition.Location = $System_Drawing_Point
$lbl_edition.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_edition.Name = "lbl_edition"

$gp_basicInformation.Controls.Add($lbl_edition)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 76
$System_Drawing_Size.Height = 20
$txt_Port.Size = $System_Drawing_Size
$txt_Port.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Port.Name = "txt_Port"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 41
$txt_Port.Location = $System_Drawing_Point
$txt_Port.TabIndex = 3

$gp_basicInformation.Controls.Add($txt_Port)

$lbl_InstanceLetter.TabIndex = 26
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 40
$System_Drawing_Size.Height = 19
$lbl_InstanceLetter.Size = $System_Drawing_Size
$lbl_InstanceLetter.Text = "S"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 22
$lbl_InstanceLetter.Location = $System_Drawing_Point
$lbl_InstanceLetter.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_InstanceLetter.Name = "lbl_InstanceLetter"

$gp_basicInformation.Controls.Add($lbl_InstanceLetter)


$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 580
$System_Drawing_Size.Height = 20
$txt_ConfigFilePath.Size = $System_Drawing_Size
$txt_ConfigFilePath.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_ConfigFilePath.Name = "txt_ConfigFilePath"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 85
$txt_ConfigFilePath.Location = $System_Drawing_Point
$txt_ConfigFilePath.TabIndex = 2

$frm_autoInst.Controls.Add($txt_ConfigFilePath)

$btn_ConfigFilePath.TabIndex = 3
$btn_ConfigFilePath.Name = "btn_ConfigFilePath"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 28
$System_Drawing_Size.Height = 23
$btn_ConfigFilePath.Size = $System_Drawing_Size
$btn_ConfigFilePath.UseVisualStyleBackColor = $True

$btn_ConfigFilePath.Text = "..."

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 598
$System_Drawing_Point.Y = 82
$btn_ConfigFilePath.Location = $System_Drawing_Point
$btn_ConfigFilePath.DataBindings.DefaultDataSourceUpdateMode = 0
$btn_ConfigFilePath.add_Click($handler_btn_ConfigFilePath_OnClick)

$frm_autoInst.Controls.Add($btn_ConfigFilePath)

$groupBox1.Name = "groupBox1"

$groupBox1.Text = "Slipstream-Components"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 154
$System_Drawing_Size.Height = 66
$groupBox1.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 472
$System_Drawing_Point.Y = 13
$groupBox1.Location = $System_Drawing_Point
$groupBox1.TabStop = $False
$groupBox1.TabIndex = 1
$groupBox1.DataBindings.DefaultDataSourceUpdateMode = 0

$frm_autoInst.Controls.Add($groupBox1)

$chkb_SP.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 95
$System_Drawing_Size.Height = 24
$chkb_SP.Size = $System_Drawing_Size
$chkb_SP.TabIndex = 7
$chkb_SP.Text = "SP included"
$chkb_SP.Checked = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 19
$chkb_SP.Location = $System_Drawing_Point
$chkb_SP.CheckState = 1
$chkb_SP.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_SP.Name = "chkb_SP"

$chkb_SP.add_CheckedChanged($handler_chkb_SP_CheckedChanged)

$groupBox1.Controls.Add($chkb_SP)


$chkb_CU.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 112
$System_Drawing_Size.Height = 22
$chkb_CU.Size = $System_Drawing_Size
$chkb_CU.TabIndex = 8
$chkb_CU.Text = "CU included"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 38
$chkb_CU.Location = $System_Drawing_Point
$chkb_CU.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_CU.Name = "chkb_CU"

$chkb_CU.add_CheckedChanged($handler_chkb_CU_CheckedChanged)

$groupBox1.Controls.Add($chkb_CU)


$gb_Agentservice.Name = "gb_Agentservice"

$gb_Agentservice.Text = "MSSQL-Agent Account"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 295
$System_Drawing_Size.Height = 71
$gb_Agentservice.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 381
$gb_Agentservice.Location = $System_Drawing_Point
$gb_Agentservice.BackColor = [System.Drawing.Color]::FromArgb(255,212,208,200)
$gb_Agentservice.TabStop = $False
$gb_Agentservice.TabIndex = 6
$gb_Agentservice.DataBindings.DefaultDataSourceUpdateMode = 0

$frm_autoInst.Controls.Add($gb_Agentservice)
$lbl_Pwd_Agent.TabIndex = 5
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 74
$System_Drawing_Size.Height = 17
$lbl_Pwd_Agent.Size = $System_Drawing_Size
$lbl_Pwd_Agent.Text = "FKID-Pwd:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 45
$lbl_Pwd_Agent.Location = $System_Drawing_Point
$lbl_Pwd_Agent.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_Pwd_Agent.Name = "lbl_Pwd_Agent"

$gb_Agentservice.Controls.Add($lbl_Pwd_Agent)

$lbl_DomFkid_Agent.TabIndex = 4
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 23
$lbl_DomFkid_Agent.Size = $System_Drawing_Size
$lbl_DomFkid_Agent.Text = "Domain\FKID:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 23
$lbl_DomFkid_Agent.Location = $System_Drawing_Point
$lbl_DomFkid_Agent.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_DomFkid_Agent.Name = "lbl_DomFkid_Agent"

$gb_Agentservice.Controls.Add($lbl_DomFkid_Agent)

$txt_Pwd_agent.PasswordChar = '*'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 199
$System_Drawing_Size.Height = 20
$txt_Pwd_agent.Size = $System_Drawing_Size
$txt_Pwd_agent.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Pwd_agent.Name = "txt_Pwd_agent"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 89
$System_Drawing_Point.Y = 41
$txt_Pwd_agent.Location = $System_Drawing_Point
$txt_Pwd_agent.TabIndex = 3

$gb_Agentservice.Controls.Add($txt_Pwd_agent)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 140
$System_Drawing_Size.Height = 20
$txt_Fkid_Agent.Size = $System_Drawing_Size
$txt_Fkid_Agent.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Fkid_Agent.Name = "txt_Fkid_Agent"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 148
$System_Drawing_Point.Y = 19
$txt_Fkid_Agent.Location = $System_Drawing_Point
$txt_Fkid_Agent.TabIndex = 1

$gb_Agentservice.Controls.Add($txt_Fkid_Agent)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 58
$System_Drawing_Size.Height = 20
$txt_Dom_Agent.Size = $System_Drawing_Size
$txt_Dom_Agent.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Dom_Agent.Name = "txt_Dom_Agent"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 89
$System_Drawing_Point.Y = 19
$txt_Dom_Agent.Location = $System_Drawing_Point
$txt_Dom_Agent.TabIndex = 0

$gb_Agentservice.Controls.Add($txt_Dom_Agent)


$gb_Sqlservice.Name = "gb_Sqlservice"

$gb_Sqlservice.Text = "MSSQL-Service Account"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 295
$System_Drawing_Size.Height = 118
$gb_Sqlservice.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 259
$gb_Sqlservice.Location = $System_Drawing_Point
$gb_Sqlservice.TabStop = $False
$gb_Sqlservice.TabIndex = 5
$gb_Sqlservice.DataBindings.DefaultDataSourceUpdateMode = 0

$frm_autoInst.Controls.Add($gb_Sqlservice)

$chkb_RsAsReAcct.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 141
$System_Drawing_Size.Height = 15
$chkb_RsAsReAcct.Size = $System_Drawing_Size
$chkb_RsAsReAcct.TabIndex = 3
$chkb_RsAsReAcct.Text = "RS uses same Account"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 80
$chkb_RsAsReAcct.Location = $System_Drawing_Point
$chkb_RsAsReAcct.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_RsAsReAcct.Name = "chkb_RsAsReAcct"

$chkb_RsAsReAcct.Enabled = $False
$chkb_RsAsReAcct.add_CheckStateChanged($handler_chkb_RsAsReAcct_checkedChanged)

$gb_Sqlservice.Controls.Add($chkb_RsAsReAcct)


$chkb_ASasREAcct.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 137
$System_Drawing_Size.Height = 16
$chkb_ASasREAcct.Size = $System_Drawing_Size
$chkb_ASasREAcct.TabIndex = 4
$chkb_ASasREAcct.Text = "AS uses same Account"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 97
$chkb_ASasREAcct.Location = $System_Drawing_Point
$chkb_ASasREAcct.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_ASasREAcct.Name = "chkb_ASasREAcct"

$chkb_ASasREAcct.Enabled = $False
$chkb_ASasREAcct.add_CheckStateChanged($handler_chkb_ASasREAccount_checkedChanged)

$gb_Sqlservice.Controls.Add($chkb_ASasREAcct)


$chkb_AgtAsReAcct.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 169
$System_Drawing_Size.Height = 16
$chkb_AgtAsReAcct.Size = $System_Drawing_Size
$chkb_AgtAsReAcct.TabIndex = 30
$chkb_AgtAsReAcct.Text = "Agent uses same account"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 63
$chkb_AgtAsReAcct.Location = $System_Drawing_Point
$chkb_AgtAsReAcct.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_AgtAsReAcct.Name = "chkb_AgtAsReAcct"

$chkb_AgtAsReAcct.Enabled = $true
$chkb_AgtAsReAcct.add_CheckStateChanged($handler_chkb_AgtAsReAcct_checkedChanged)

$gb_Sqlservice.Controls.Add($chkb_AgtAsReAcct)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 58
$System_Drawing_Size.Height = 20
$txt_dom.Size = $System_Drawing_Size
$txt_dom.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_dom.Name = "txt_dom"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 19
$txt_dom.Location = $System_Drawing_Point
$txt_dom.TabIndex = 0

$gb_Sqlservice.Controls.Add($txt_dom)

$lbl_DomFkid.TabIndex = 28
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 79
$System_Drawing_Size.Height = 23
$lbl_DomFkid.Size = $System_Drawing_Size
$lbl_DomFkid.Text = "Domain\FKID:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 22
$lbl_DomFkid.Location = $System_Drawing_Point
$lbl_DomFkid.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_DomFkid.Name = "lbl_DomFkid"

$gb_Sqlservice.Controls.Add($lbl_DomFkid)

$lbl_Pwd.TabIndex = 29
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 82
$System_Drawing_Size.Height = 23
$lbl_Pwd.Size = $System_Drawing_Size
$lbl_Pwd.Text = "FKID-Pwd:"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 45
$lbl_Pwd.Location = $System_Drawing_Point
$lbl_Pwd.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_Pwd.Name = "lbl_Pwd"

$gb_Sqlservice.Controls.Add($lbl_Pwd)

$txt_Pwd.PasswordChar = '*'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 193
$System_Drawing_Size.Height = 20
$txt_Pwd.Size = $System_Drawing_Size
$txt_Pwd.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Pwd.Name = "txt_Pwd"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 42
$txt_Pwd.Location = $System_Drawing_Point
$txt_Pwd.TabIndex = 2

$gb_Sqlservice.Controls.Add($txt_Pwd)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 135
$System_Drawing_Size.Height = 20
$txt_Fkid.Size = $System_Drawing_Size
$txt_Fkid.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_Fkid.Name = "txt_Fkid"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 153
$System_Drawing_Point.Y = 19
$txt_Fkid.Location = $System_Drawing_Point
$txt_Fkid.TabIndex = 1

$gb_Sqlservice.Controls.Add($txt_Fkid)


$txt_infobox.Multiline = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 614
$System_Drawing_Size.Height = 89
$txt_infobox.Size = $System_Drawing_Size
$txt_infobox.DataBindings.DefaultDataSourceUpdateMode = 0
$txt_infobox.ReadOnly = $True
$txt_infobox.ScrollBars = 2
$txt_infobox.Name = "txt_infobox"
$txt_infobox.BackColor = [System.Drawing.Color]::FromArgb(255,255,255,225)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 458
$txt_infobox.Location = $System_Drawing_Point
$txt_infobox.TabIndex = 17

$frm_autoInst.Controls.Add($txt_infobox)

$btn_unlock.TabIndex = 13
$btn_unlock.Name = "btn_unlock"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 36
$btn_unlock.Size = $System_Drawing_Size
$btn_unlock.UseVisualStyleBackColor = $True

$btn_unlock.Text = "pending reboot reset"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 328
$System_Drawing_Point.Y = 553
$btn_unlock.Location = $System_Drawing_Point
$btn_unlock.DataBindings.DefaultDataSourceUpdateMode = 0
$btn_unlock.add_Click($handler_btn_RebootReset_OnClick)

$frm_autoInst.Controls.Add($btn_unlock)

$gb_binaries.Name = "gb_binaries"

$gb_binaries.Text = "Drive for Binaries"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 142
$System_Drawing_Size.Height = 71
$gb_binaries.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 313
$System_Drawing_Point.Y = 111
$gb_binaries.Location = $System_Drawing_Point
$gb_binaries.BackColor = [System.Drawing.Color]::FromArgb(255,212,208,200)
$gb_binaries.TabStop = $False
$gb_binaries.TabIndex = 9
$gb_binaries.DataBindings.DefaultDataSourceUpdateMode = 0

$frm_autoInst.Controls.Add($gb_binaries)
$cb_bin.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 21
$cb_bin.Size = $System_Drawing_Size
$cb_bin.DataBindings.DefaultDataSourceUpdateMode = 0
$cb_bin.Name = "cb_bin"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 74
$System_Drawing_Point.Y = 19
$cb_bin.Location = $System_Drawing_Point
$cb_bin.TabIndex = 10
$cb_bin.add_SelectionChangeCommitted($handler_cb_bin_SelectionChangeCommited)

$gb_binaries.Controls.Add($cb_bin)


$btn_verify.TabIndex = 14
$btn_verify.Name = "btn_verify"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 36
$btn_verify.Size = $System_Drawing_Size
$btn_verify.UseVisualStyleBackColor = $True

$btn_verify.Text = "Verify Values"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 470
$System_Drawing_Point.Y = 553
$btn_verify.Location = $System_Drawing_Point
$btn_verify.DataBindings.DefaultDataSourceUpdateMode = 0
$btn_verify.add_Click($handler_btn_verify_OnClick)

$frm_autoInst.Controls.Add($btn_verify)

$btn_reset.TabIndex = 16
$btn_reset.Name = "btn_reset"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 74
$System_Drawing_Size.Height = 21
$btn_reset.Size = $System_Drawing_Size
$btn_reset.UseVisualStyleBackColor = $True

$btn_reset.Text = "Reset Form"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 553
$btn_reset.Location = $System_Drawing_Point
$btn_reset.DataBindings.DefaultDataSourceUpdateMode = 0
$btn_reset.add_Click($handler_btn_resetForm_OnClick)

$frm_autoInst.Controls.Add($btn_reset)

$btn_create.TabIndex = 15
$btn_create.Name = "btn_create"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 36
$btn_create.Size = $System_Drawing_Size
$btn_create.UseVisualStyleBackColor = $True

$btn_create.Text = "Start Installation"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 551
$System_Drawing_Point.Y = 553
$btn_create.Location = $System_Drawing_Point
$btn_create.DataBindings.DefaultDataSourceUpdateMode = 0
$btn_create.add_Click($handler_btn_Start_onClick)

$frm_autoInst.Controls.Add($btn_create)

$gb_UserDB.Name = "gb_UserDB"

$gb_UserDB.Text = "Drive for User-datbases"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 165
$System_Drawing_Size.Height = 69
$gb_UserDB.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 461
$System_Drawing_Point.Y = 184
$gb_UserDB.Location = $System_Drawing_Point
$gb_UserDB.TabStop = $False
$gb_UserDB.TabIndex = 12
$gb_UserDB.DataBindings.DefaultDataSourceUpdateMode = 0

$frm_autoInst.Controls.Add($gb_UserDB)
$cb_UserDbLog.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 21
$cb_UserDbLog.Size = $System_Drawing_Size
$cb_UserDbLog.DataBindings.DefaultDataSourceUpdateMode = 0
$cb_UserDbLog.Name = "cb_UserDbLog"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 88
$System_Drawing_Point.Y = 41
$cb_UserDbLog.Location = $System_Drawing_Point
$cb_UserDbLog.TabIndex = 16

$gb_UserDB.Controls.Add($cb_UserDbLog)

$lbl_UserDBLog.TabIndex = 22
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 23
$lbl_UserDBLog.Size = $System_Drawing_Size
$lbl_UserDBLog.Text = "TLog-Files"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 44
$lbl_UserDBLog.Location = $System_Drawing_Point
$lbl_UserDBLog.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_UserDBLog.Name = "lbl_UserDBLog"

$gb_UserDB.Controls.Add($lbl_UserDBLog)

$cb_UserDBData.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 21
$cb_UserDBData.Size = $System_Drawing_Size
$cb_UserDBData.DataBindings.DefaultDataSourceUpdateMode = 0
$cb_UserDBData.Name = "cb_UserDBData"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 88
$System_Drawing_Point.Y = 19
$cb_UserDBData.Location = $System_Drawing_Point
$cb_UserDBData.TabIndex = 15
$cb_UserDBData.add_SelectionChangeCommitted($handler_cb_UserDBData_SelectionChangeCommited)

$gb_UserDB.Controls.Add($cb_UserDBData)

$lbl_userDBData.TabIndex = 21
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 140
$System_Drawing_Size.Height = 23
$lbl_userDBData.Size = $System_Drawing_Size
$lbl_userDBData.Text = "DataFiles"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 22
$lbl_userDBData.Location = $System_Drawing_Point
$lbl_userDBData.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_userDBData.Name = "lbl_userDBData"

$gb_UserDB.Controls.Add($lbl_userDBData)


$gb_tempDb.Name = "gb_tempDb"

$gb_tempDb.Text = "Drive for TempDB"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 141
$System_Drawing_Size.Height = 69
$gb_tempDb.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 314
$System_Drawing_Point.Y = 184
$gb_tempDb.Location = $System_Drawing_Point
$gb_tempDb.TabStop = $False
$gb_tempDb.TabIndex = 11
$gb_tempDb.DataBindings.DefaultDataSourceUpdateMode = 0

$frm_autoInst.Controls.Add($gb_tempDb)
$cb_TempDBLog.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 21
$cb_TempDBLog.Size = $System_Drawing_Size
$cb_TempDBLog.DataBindings.DefaultDataSourceUpdateMode = 0
$cb_TempDBLog.Name = "cb_TempDBLog"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 73
$System_Drawing_Point.Y = 40
$cb_TempDBLog.Location = $System_Drawing_Point
$cb_TempDBLog.TabIndex = 14

$gb_tempDb.Controls.Add($cb_TempDBLog)

$cb_TempDBData.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 21
$cb_TempDBData.Size = $System_Drawing_Size
$cb_TempDBData.DataBindings.DefaultDataSourceUpdateMode = 0
$cb_TempDBData.Name = "cb_TempDBData"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 73
$System_Drawing_Point.Y = 19
$cb_TempDBData.Location = $System_Drawing_Point
$cb_TempDBData.TabIndex = 13
$cb_TempDBData.add_SelectionChangeCommitted($handler_cb_TempDBdata_SelectionChangeCommited)

$gb_tempDb.Controls.Add($cb_TempDBData)

$lbl_TempDBLog.TabIndex = 1
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 23
$lbl_TempDBLog.Size = $System_Drawing_Size
$lbl_TempDBLog.Text = "TLog-Files"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 44
$lbl_TempDBLog.Location = $System_Drawing_Point
$lbl_TempDBLog.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_TempDBLog.Name = "lbl_TempDBLog"

$gb_tempDb.Controls.Add($lbl_TempDBLog)

$lbl_TempDBData.TabIndex = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 23
$lbl_TempDBData.Size = $System_Drawing_Size
$lbl_TempDBData.Text = "DataFiles"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 22
$lbl_TempDBData.Location = $System_Drawing_Point
$lbl_TempDBData.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_TempDBData.Name = "lbl_TempDBData"

$gb_tempDb.Controls.Add($lbl_TempDBData)


$gb_systemDBs.Name = "gb_systemDBs"

$gb_systemDBs.Text = "Drive for system-databases"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 165
$System_Drawing_Size.Height = 71
$gb_systemDBs.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 461
$System_Drawing_Point.Y = 111
$gb_systemDBs.Location = $System_Drawing_Point
$gb_systemDBs.TabStop = $False
$gb_systemDBs.TabIndex = 10
$gb_systemDBs.DataBindings.DefaultDataSourceUpdateMode = 0

$frm_autoInst.Controls.Add($gb_systemDBs)
$cb_sysDBLog.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 21
$cb_sysDBLog.Size = $System_Drawing_Size
$cb_sysDBLog.DataBindings.DefaultDataSourceUpdateMode = 0
$cb_sysDBLog.Name = "cb_sysDBLog"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 88
$System_Drawing_Point.Y = 41
$cb_sysDBLog.Location = $System_Drawing_Point
$cb_sysDBLog.TabIndex = 12

$gb_systemDBs.Controls.Add($cb_sysDBLog)

$lbl_sysDBdata.TabIndex = 20
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 68
$System_Drawing_Size.Height = 23
$lbl_sysDBdata.Size = $System_Drawing_Size
$lbl_sysDBdata.Text = "DataFiles"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 22
$lbl_sysDBdata.Location = $System_Drawing_Point
$lbl_sysDBdata.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_sysDBdata.Name = "lbl_sysDBdata"

$gb_systemDBs.Controls.Add($lbl_sysDBdata)

$lbl_sysDBLog.TabIndex = 24
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 23
$lbl_sysDBLog.Size = $System_Drawing_Size
$lbl_sysDBLog.Text = "TLog-Files"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 44
$lbl_sysDBLog.Location = $System_Drawing_Point
$lbl_sysDBLog.DataBindings.DefaultDataSourceUpdateMode = 0
$lbl_sysDBLog.Name = "lbl_sysDBLog"

$gb_systemDBs.Controls.Add($lbl_sysDBLog)

$cb_sysDBdata.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 21
$cb_sysDBdata.Size = $System_Drawing_Size
$cb_sysDBdata.DataBindings.DefaultDataSourceUpdateMode = 0
$cb_sysDBdata.Name = "cb_sysDBdata"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 88
$System_Drawing_Point.Y = 19
$cb_sysDBdata.Location = $System_Drawing_Point
$cb_sysDBdata.TabIndex = 11
$cb_sysDBdata.add_SelectionChangeCommitted($handler_cb_sysDBdata_SelectionChangeCommitted)

$gb_systemDBs.Controls.Add($cb_sysDBdata)


$gb_Components.Name = "gb_Components"

$gb_Components.Text = "MSSQL-Components"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 454
$System_Drawing_Size.Height = 66
$gb_Components.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 13
$gb_Components.Location = $System_Drawing_Point
$gb_Components.TabStop = $False
$gb_Components.TabIndex = 0
$gb_Components.DataBindings.DefaultDataSourceUpdateMode = 0

$frm_autoInst.Controls.Add($gb_Components)

$chkB_RS.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 127
$System_Drawing_Size.Height = 24
$chkB_RS.Size = $System_Drawing_Size
$chkB_RS.TabIndex = 3
$chkB_RS.Text = "Reporting-Services"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 316
$System_Drawing_Point.Y = 19
$chkB_RS.Location = $System_Drawing_Point
$chkB_RS.DataBindings.DefaultDataSourceUpdateMode = 0
$chkB_RS.Name = "chkB_RS"

$chkB_RS.add_CheckedChanged($handler_chkB_RS_checkedChanged)

$gb_Components.Controls.Add($chkB_RS)


$chkB_AS.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 116
$System_Drawing_Size.Height = 24
$chkB_AS.Size = $System_Drawing_Size
$chkB_AS.TabIndex = 5
$chkB_AS.Text = "Analysis Services"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 169
$System_Drawing_Point.Y = 38
$chkB_AS.Location = $System_Drawing_Point
$chkB_AS.DataBindings.DefaultDataSourceUpdateMode = 0
$chkB_AS.Name = "chkB_AS"

$chkB_AS.add_CheckedChanged($handler_chkB_AS_checkedChanged)

$gb_Components.Controls.Add($chkB_AS)


$chkb_FTS.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 127
$System_Drawing_Size.Height = 20
$chkb_FTS.Size = $System_Drawing_Size
$chkb_FTS.TabIndex = 6
$chkb_FTS.Text = "Fulltext Search"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 316
$System_Drawing_Point.Y = 40
$chkb_FTS.Location = $System_Drawing_Point
$chkb_FTS.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_FTS.Name = "chkb_FTS"

$chkb_FTS.Enabled = $False
$chkb_FTS.Visible = $False
$chkb_FTS.add_CheckedChanged($handler_chkB_FTS_checkedChanged)

$gb_Components.Controls.Add($chkb_FTS)


$chkb_SSIS.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 129
$System_Drawing_Size.Height = 24
$chkb_SSIS.Size = $System_Drawing_Size
$chkb_SSIS.TabIndex = 4
$chkb_SSIS.Text = "Integration Services"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 38
$chkb_SSIS.Location = $System_Drawing_Point
$chkb_SSIS.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_SSIS.Name = "chkb_SSIS"

$chkb_SSIS.add_CheckedChanged($handler_chkB_IS_checkedChanged)

$gb_Components.Controls.Add($chkb_SSIS)


$chkB_MgmtStudio.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 132
$System_Drawing_Size.Height = 24
$chkB_MgmtStudio.Size = $System_Drawing_Size
$chkB_MgmtStudio.TabIndex = 2
$chkB_MgmtStudio.Text = "Management Studio"
$chkB_MgmtStudio.Checked = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 169
$System_Drawing_Point.Y = 19
$chkB_MgmtStudio.Location = $System_Drawing_Point
$chkB_MgmtStudio.CheckState = 1
$chkB_MgmtStudio.DataBindings.DefaultDataSourceUpdateMode = 0
$chkB_MgmtStudio.Name = "chkB_MgmtStudio"

$chkB_MgmtStudio.add_CheckedChanged($handler_chkB_MgmtStudio_checkedChanged)

$gb_Components.Controls.Add($chkB_MgmtStudio)


$chkb_RelationalEngine.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 185
$System_Drawing_Size.Height = 26
$chkb_RelationalEngine.Size = $System_Drawing_Size
$chkb_RelationalEngine.TabIndex = 1
$chkb_RelationalEngine.Text = "Sql Server Relational Engine"
$chkb_RelationalEngine.Checked = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 19
$chkb_RelationalEngine.Location = $System_Drawing_Point
$chkb_RelationalEngine.CheckState = 1
$chkb_RelationalEngine.DataBindings.DefaultDataSourceUpdateMode = 0
$chkb_RelationalEngine.Name = "chkb_RelationalEngine"

$chkb_RelationalEngine.add_CheckedChanged($handler_chkB_RelationalEngine_checkedChanged)

$gb_Components.Controls.Add($chkb_RelationalEngine)


$openFileDialog1.DefaultExt = "xml"
$openFileDialog1.Filter = "configuration|*.xml|all files|*.*"
$openFileDialog1.ShowHelp = $True
$openFileDialog1.Title = "Open ConfigFile"
$openFileDialog1.InitialDirectory = ".\scripts"
$openFileDialog1.FileName = "configuration.xml"

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $frm_autoInst.WindowState
#Init the OnLoad event to correct the initial state of the form
$frm_autoInst.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$frm_autoInst.ShowDialog()| Out-Null

} #End Function


$DebugPreference="SilentlyContinue"
Set PS-Debug-Strict

$mypath = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $mypath
. main
