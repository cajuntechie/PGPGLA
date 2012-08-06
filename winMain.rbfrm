#tag Window
Begin Window winMain
   BackColor       =   &hFFFFFF
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   3.65e+2
   ImplicitInstance=   True
   LiveResize      =   False
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   385839103
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   False
   Title           =   "GPG Group Line Automator"
   Visible         =   True
   Width           =   3.92e+2
   Begin TextArea txtOutput
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   &hFFFFFF
      Bold            =   ""
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   289
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   ""
      Left            =   10
      LimitText       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   ""
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollbarVertical=   True
      Styled          =   True
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &h000000
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   14
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   372
   End
   Begin BevelButton btnImport
      AcceptFocus     =   False
      AutoDeactivate  =   True
      BackColor       =   "&c00000000"
      Bevel           =   0
      Bold            =   False
      ButtonType      =   0
      Caption         =   "Go!"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      Enabled         =   True
      HasBackColor    =   False
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   ""
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   250
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      MenuValue       =   0
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   "&c00000000"
      TextFont        =   "System"
      TextSize        =   ""
      TextUnit        =   0
      Top             =   323
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   60
   End
   Begin BevelButton btnExit
      AcceptFocus     =   False
      AutoDeactivate  =   True
      BackColor       =   "&c00000000"
      Bevel           =   0
      Bold            =   False
      ButtonType      =   0
      Caption         =   "Exit"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      Enabled         =   True
      HasBackColor    =   False
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   ""
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   322
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      MenuValue       =   0
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   "&c00000000"
      TextFont        =   "System"
      TextSize        =   ""
      TextUnit        =   0
      Top             =   323
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   60
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  me.Title = "PGPNET Group Line Automater"
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function backup_conf_file() As Boolean
		  // This method wll create a backup of the gpg.conf file. The backup will be
		  // called GPG.CONF.BAK.
		  
		  Dim newFolder as FolderItem
		  Dim source as FolderItem
		  Dim destination as FolderItem
		  Dim d as New Date
		  
		  if TargetWin32 then
		    source = SpecialFolder.ApplicationData.Child("gnupg").Child("gpg.conf")
		    destination = SpecialFolder.ApplicationData.Child("gnupg").Child("gpg.conf.bak")
		  else
		    source = SpecialFolder.Home.Child(".gnupg").Child("gpg.conf")
		    destination = SpecialFolder.Home.Child(".gnupg").Child("gpg.conf.bak")
		  end if
		  if destination.Exists then
		    txtOutput.AppendText("Removing existing gpg.conf.bak file..." + EndOfLine)
		    destination.Delete
		  end if
		  source.CopyFileTo destination
		  if source.LastErrorCode = 0 then
		    return true
		  else
		    return false
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function create_group_line() As String
		  // This method parses the pgpnet@yahoogroups.com.txt file and
		  // creates a group line compatible with the operating system in
		  // use. It returns a fully formed group line ready to be inserted into
		  // the gpg.conf file.
		  
		  Dim fi as FolderItem = GetFolderItem("pgpnet@yahoogroups.com.txt")
		  Dim inStream as TextInputStream
		  Dim sLineFromFile as String
		  Dim sGroupLine as String
		  
		  if TargetWin32 then
		    sGroupLine = "group <pgpnet@yahoogroups.com>="
		  else
		    sGroupLine = "group pgpnet@yahoogroups.com="
		  end if
		  
		  try
		    inStream = TextInputStream.Open(fi)
		  catch err as IOException
		    return str(Nil)
		  end try
		  
		  while not inStream.EOF
		    sLineFromFile = inStream.ReadLine
		    if left(sLineFromFile, 1) <> "#" then
		      sGroupLine = sGroupLine + Left(sLineFromFile, 18) + " "
		    end if
		  wend
		  
		  inStream.Close
		  return sGroupLine
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function importPGPKeys() As Boolean
		  // This method will use the keys in the PGPNET.asc file to import
		  // the PGP keys into the users keyring. It returns true or false
		  // based on if the import was successful.
		  
		  Dim sh as new Shell
		  
		  sh.Execute("gpg --import PGPNET.asc")
		  if left(sh.Result, 10) = "gpg: can't" then
		    return false
		  else
		    return true
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function insert_group_line(sGroupLine as String) As Boolean
		  // This method will insert the new group line into the users gpg.conf file. It
		  // will remove the previous group line for the group and replace it with the
		  // new one.
		  
		  
		  Dim iFile as FolderItem
		  Dim oFile as FolderItem
		  Dim iStream as TextInputStream
		  Dim oStream as TextOutputStream
		  Dim sLineFromFile as String
		  Dim MoveFileName as FolderItem
		  
		  if TargetLinux or TargetMacOS then
		    iFile = SpecialFolder.Home.Child(".gnupg").Child("gpg.conf")
		  else
		    iFile = SpecialFolder.ApplicationData.Child("gnupg").Child("gpg.conf")
		  end if
		  
		  oFile = SpecialFolder.CurrentWorkingDirectory.Child("gpg.tmp")
		  
		  iStream = TextInputStream.Open(iFile)
		  oStream = TextOutputStream.Create(oFile)
		  
		  while not iStream.EOF
		    sLineFromFile = iStream.ReadLine
		    if left(sLineFromFile, 12) = "group pgpnet" or left(sLineFromFile, 13) = "group <pgpnet" then
		      oStream.WriteLine(sGroupLine)
		    else
		      oStream.WriteLine(sLineFromFIle)
		    end if
		  wend
		  
		  // Rename the files accordingly
		  
		  iFile.Delete
		  iStream.Close
		  oStream.Close
		  oFile.Name = "gpg.conf"
		  
		  try
		    if TargetWin32 then
		      oFile.MoveFileTo(SpecialFolder.ApplicationData.Child("gnupg"))
		      if oFile.LastErrorCode > 0 then
		        txtOutput.AppendText("Error moving files. Error code: " + str(oFile.LastErrorCode))
		      end if
		    else
		      oFile.MoveFileTo(SpecialFolder.Home.Child(".gnupg"))
		      if oFile.LastErrorCode > 0 then
		        txtOutput.AppendText ("Error moving files. Error code: " + str(oFile.LastErrorCode))
		      end if
		    end if
		    return true
		  catch err as IOException
		    txtOutput.AppendText("Error: " + err.Message)
		  end try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function verify_required_file_existance() As Boolean
		  // Make sure that the two files (PGPNET.asc and pgpnet@yahoogroups.com.txt) are
		  // present and available for use by the program. These two files should be in the same
		  // directory as the program itself.
		  
		  Dim fi as FolderItem = GetFolderItem("PGPNET.asc")
		  Dim fit as FolderItem = GetFolderItem("pgpnet@yahoogroups.com.txt")
		  
		  if not fi.exists or not fit.Exists then
		    return false
		  else
		    return true
		  end if
		  
		End Function
	#tag EndMethod


#tag EndWindowCode

#tag Events btnImport
	#tag Event
		Sub Action()
		  // Run the required methods to import the keys into the users
		  // leyring and create the group line.
		  
		  Dim retResult  as Boolean
		  Dim sRetResult as String
		  
		  txtOutput.AppendText("Backing up your GPG configuration file..." + EndOfLine)
		  retResult = backup_conf_file
		  if retResult = false then
		    txtOutput.AppendText("Could not back up your GPG configuration file. Not continuing." + EndOfLine)
		    Exit
		  end if
		  txtOutput.AppendText("Verifying that required files are present..." + EndOfLine)
		  retResult = verify_required_file_existance
		  if retResult = false then
		    txtOutput.AppendText("Required files are missing. Cannot continue." + EndOfLine)
		    Exit
		  else
		    txtOutput.AppendText("Required files are available..." + EndOfLine)
		    txtOutput.AppendText("Attempting to import member keys from file..." + EndOfLine)
		    retResult = importPGPKeys
		    if retResult = False then
		      txtOutput.AppendText("Member keys could not be imported. Cannot continue.")
		      Exit
		    else
		      txtOutPut.AppendText("Member keys successfully imported. Creating group line..." + EndOfLine)
		      sretResult = create_group_line
		      if sRetResult =str( Nil)  then
		        txtOutput.AppendText("Group line could not be created. Cannot continue.")
		        Exit
		      else
		        txtOutput.AppendText("Group line created. Inserting into gpg.conf..." + EndOfLine)
		        retResult = insert_group_line(sRetResult)
		        if retResult = false then
		          txtOutput.AppendText("Could not insert group line into gpg.conf. Exiting...")
		          Exit
		        else
		          txtOutput.AppendText("New group line successfully inserted. You're good to go!" + EndOfLine)
		        end if
		      end if
		    end if
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnExit
	#tag Event
		Sub Action()
		  Quit
		End Sub
	#tag EndEvent
#tag EndEvents
