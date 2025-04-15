{Sample of code implementing a Terminal, using the unit "UnTerminal".
 The output is captured using the Line by Line detection}
unit Unit1;
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, EditBtn, UnTerminal;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonDownload: TButton;
    DirectoryEdit1: TDirectoryEdit;
    label2: TLabel;
    label3: TLabel;
    Memo1: TMemo;
    txtCommand: TEdit;
    procedure ButtonDownloadClick(Sender: TObject);
    procedure DirectoryEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure procChangeState(State: string; pFinal: TPoint);
    procedure procLineCompleted(const lin: string);
    procedure procReadData(nDat: integer; const lastLin: string);
  private
    { private declarations }
  public
    LinPartial: boolean;
  end;

var
  Form1: TForm1;
  proc: TConsoleProc;
  dload: String;
  cdload: String;
  yturl: String;
  ytdlp: String;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ButtonDownloadClick(Sender: TObject);
begin
  Memo1.Lines.Clear;
  yturl := txtCommand.Text;
  ytdlp := 'yt-dlp.exe -f 137+140 ' + yturl;
  proc.SendLn(ytdlp);
end;

procedure TForm1.DirectoryEdit1Change(Sender: TObject);
begin
  dload := DirectoryEdit1.Directory;
  cdload := 'cd ' + dload;
  proc.SendLn(cdload);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  proc:= TConsoleProc.Create(nil);
  proc.LineDelimSend := LDS_CRLF;
  proc.OnLineCompleted:=@procLineCompleted;
  proc.OnReadData:=@procReadData;
  proc.OnChangeState:=@procChangeState;
  dload := GetUserDir + 'Downloads';
  DirectoryEdit1.Directory := dload;
  proc.Open('cmd.exe /K cd ', dload);
  proc.SendLn('set PATH=C:\PPD\libs;C:\PPD\libs\ffmpeg\bin;%PATH%');
  proc.SendLn('yt-dlp.exe -U');
  proc.SendLn('ffmpeg -version');
  {$ifdef linux}
  txtProcess.Text:= 'bash';
  txtCommand.Text := 'ls';
  proc.LineDelimSend := LDS_LF;
  {$endif}
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  proc.Destroy;
end;


procedure TForm1.procChangeState(State: string; pFinal: TPoint);
begin

end;

procedure TForm1.procLineCompleted(const lin: string);
begin
  if LinPartial then begin
    Memo1.Lines[Memo1.Lines.Count-1] := lin; 
    LinPartial := false;
  end else begin  
    Memo1.Lines.Add(lin);
  end;
end;

procedure TForm1.procReadData(nDat: integer; const lastLin: string);
begin
  LinPartial := true; 
  Memo1.Lines.Add(lastLin); 
end;


end.

