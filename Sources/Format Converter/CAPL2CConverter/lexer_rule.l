%{
#undef YYLMAX
#define YYLMAX 12000
%}
WS   [ \t\n]
WSP  [ \t]
ANY  [a-zA-Z0-9_,." \n\t+{}[\]():>`~!@#$%^&/\*=-]
STRING \"(\\.|[^\\"])*\"  
CHARACTER '.'
DEFARGUMENTS [a-zA-Z0-9_,. \n\t[\]:/*\\ ]
CALLARGUMENTS [a-zA-Z0-9_+*=/%]*
CAPL_EVENT_ARGUMENTS ([a-zA-Z0-9_\-,.' *\n\t[\]:/*\\]|{CHARACTER})
STORAGEARGUMENTS ([a-zA-Z0-9_,. '�()\-+*/=\n\t[\]:/*\\{}!"]|{CHARACTER})
LINECOMMENT	"//".*
BLOCKCOMMENT "/*"([^\*]|\*[^*/])*"*/"
CAPL_CONTROLLER_FUN ("swapDWord"|"swapInt"|"swapLong"|"swapWord")
CAPL_FILE_FUN ("fileClose"|"fileGetBinaryBlock"|"fileGetString"|"fileGetStringSZ"|"filePutString"|"fileRewind"|"fileWriteBinaryBlock")
CAPL_FILEOP_FUN ("getProfileArray"|"getProfileFloat"|"getProfileInt"|"getProfileString"|"openFileRead"|"openFileWrite"|"setFilePath"|"setWritePath"|"writeProfileFloat"|"writeProfileInt"|"writeProfileString")
CAPL_STRING_FUN ("atodbl"|"ltoa"|"snprintf"|"strlen"|"strncat"|"strncmp_off"|"strncpy_off"|"strstr"|"strstr_off"|"substr_cpy"|"substr_cpy_off"|"keypressed"|"timenow"|"getmessagename"|"getfirstcandbname")
CAPL_TRIGONOMETRIC_FUN ("_max"|"_min"|"_pow"|"_round"|"abs"|"cos"|"exp"|"random"|"sin"|"sqrt"|"write"|"cancelTimer")
ALNUM   [a-zA-Z0-9_]
ALPHA	[a-zA-Z_]
NOALNUM  [^a-zA-Z0-9_]
CAPL_SUP_EVENTS ("PreStart"|"Start"|"stopMeasurement"|"busOff"|"timer"|"key"|"message"|"errorActive"|"errorPassive"|"warningLimit"|"errorFrame"|"envVar")
STORAGETYPE	("int"|"word"|"long"|"dword"|"float"|"double"|"message"|"byte"|"msTimer"|"timer"|"char")
STORAGETYPEDEF	("int"|"word"|"long"|"dword"|"float"|"double"|"message"|"byte"|"msTimer"|"timer"|"void")
TYPECASTETYPE ("int"|"word"|"long"|"dword"|"float"|"double"|"byte")
MESSAGE "message"
ARRAYBOUND	[{WS}*[a-zA-Z0-9_]+{WS}*]
VALIDSPACE ({WS}|{LINECOMMENT}|{BLOCKCOMMENT})

%{
#include "LexerHandlers.h"
%}	
%x  FirstParse
%x  SecondParse
%x  ThirdParse
%x  FourthParse
%x  FifthParse
%x	VariableParse
%option stack
%option never-interactive 
%option array
%option yylineno
%%
<SecondParse>{LINECOMMENT} {ECHO;}
<SecondParse>{BLOCKCOMMENT} {ECHO;}
<ThirdParse>{LINECOMMENT} {ECHO;}
<ThirdParse>{BLOCKCOMMENT} {ECHO;}
<FirstParse>{VALIDSPACE}("msTimer"|"Timer"){VALIDSPACE}*[a-zA-Z0-9,_/*]*";" vStoreTimers();
<FirstParse>"on"{VALIDSPACE}*"key"{CAPL_EVENT_ARGUMENTS}*{VALIDSPACE}*"{" vKeyStoreHeader();
<FirstParse>{WS}*{STORAGETYPEDEF}?({WS}|{LINECOMMENT}|{BLOCKCOMMENT})*{ALPHA}{ALNUM}*{WS}*"("{WS}*{DEFARGUMENTS}*{WS}*")"({WS}|{LINECOMMENT}|{BLOCKCOMMENT})*"{" vFuNdef();
<FirstParse>\n { }
<FirstParse>. { }
<VariableParse>{VALIDSPACE} {ECHO;};
<VariableParse>"const "{VALIDSPACE}*({STORAGETYPE}{VALIDSPACE}+)*{ALPHA}{STORAGEARGUMENTS}*{VALIDSPACE}*";" onConstGlobalVariables(true);
<VariableParse>{STORAGETYPE}+{VALIDSPACE}+{ALNUM}{STORAGEARGUMENTS}*{VALIDSPACE}*";" onGlobalVariables();
<VariableParse>({WS}|{LINECOMMENT}|{BLOCKCOMMENT})*"}" onGlobalVariablesHeader(FALSE);
<VariableParse>.  ECHO;
<VariableParse>\n  ECHO;
<SecondParse>({WS}|{LINECOMMENT}|{BLOCKCOMMENT})*"variables"({WS}|{LINECOMMENT}|{BLOCKCOMMENT})*"{" onGlobalVariablesHeader(TRUE);
<SecondParse>{STORAGETYPE}+{VALIDSPACE}+{ALPHA}{STORAGEARGUMENTS}*{VALIDSPACE}*";" onLocalVariables();
<SecondParse>"const "{VALIDSPACE}*({STORAGETYPE}{VALIDSPACE}+)*{ALPHA}{STORAGEARGUMENTS}*{VALIDSPACE}*";" onConstGlobalVariables(false);
<SecondParse>"on"{VALIDSPACE}+{CAPL_SUP_EVENTS}{VALIDSPACE}*{CAPL_EVENT_ARGUMENTS}*{VALIDSPACE}*"{" vHandleCaplEvents();
<SecondParse>"on"{VALIDSPACE}+{CAPL_SUP_EVENTS}{VALIDSPACE}*{CAPL_EVENT_ARGUMENTS}*{VALIDSPACE}*"{" ECHO;;
<SecondParse>{WS}*{STORAGETYPEDEF}?({WS}|{LINECOMMENT}|{BLOCKCOMMENT})*{ALPHA}{ALNUM}*{WS}*"("{WS}*{DEFARGUMENTS}*{WS}*")"({WS}|{LINECOMMENT}|{BLOCKCOMMENT})*"{" vHandleUtilityFun();
<SecondParse,WritePhase>"this."+{ALNUM}+		vCnvrtThisData();  
<SecondParse,WritePhase>"this"/[^a-zA-Z]				vCnvrtThis(); 
<SecondParse,WritePhase>"errorFrame"			; 
<VarDecl,SecondParse>[ \t;,]*{ALNUM}+{WS}*"="{WS}*"("{WS}*"message"{WS}*"*"{WS}*")"{WS}*{ALNUM}*{WS}*";"   vHandleMsgTypeCaste();
<VarDecl,SecondParse>[ \t;,]{WS}*"("{WS}*{TYPECASTETYPE}{WS}*")"	   vHandleTypeCaste();
<SecondParse>{WS}*({CAPL_CONTROLLER_FUN}|{CAPL_FILE_FUN}|{CAPL_FILEOP_FUN}|{CAPL_STRING_FUN}|{CAPL_TRIGONOMETRIC_FUN}){WS}*"(" vHandleCaplSupportedFunction();
<SecondParse>{WS}*{ALPHA}{ALNUM}*{WS}*"(" vHandleFunctionCall();
<SecondParse>{STRING}		ECHO;
<ThirdParse>{STRING}		ECHO;
<ThirdParse,WritePhase>{ALNUM}+"."("id"|"dlc"|"dir"|"can"|"time"){NOALNUM}       vHandleMessageMembers(); 
<ThirdParse,WritePhase>{ALPHA}{ALNUM}*{WS}*+"."{ALPHA}{ALNUM}*			  vHandleDot();
<SecondParse>[a-zA-Z0-9_[\]]+{WS}*"."{WS}*("byte"|"long"|"word"){VALIDSPACE}*"("{VALIDSPACE}*[a-zA-Z_0-9+-]+{VALIDSPACE}*")"  vHandleByte(yytext);  
<ThirdParse>[a-zA-Z0-9_[\]]+{WS}*"."{WS}*("byte"|"long"|"word"){VALIDSPACE}*"("{VALIDSPACE}*[a-zA-Z_0-9+-]+{VALIDSPACE}*")"  vHandleByte(yytext);  
<ThirdParse>.		ECHO;
<ThirdParse>\n		{nLineNum++;  ECHO;}
<SecondParse>.		ECHO;
<SecondParse>\n		ECHO;
<FourthParse>{ALNUM}+ SearchForRepeatedMessage();	
<FourthParse>.		ECHO;
<FourthParse>\n		ECHO;
<FifthParse>{WS}+char{WS}+{ALNUM}+{WS}*{ARRAYBOUND}{WS}*{ARRAYBOUND}{WS}*= vUpdateArraySize();
<FifthParse>_7016A3A052554b2dA5526D504AA2CE1A ;
<FifthParse>.		ECHO;
<FifthParse>\n		ECHO;
%%
void yyerror(const char *str)
{
	//fprintf(stderr,"error: %s\n",str);
}
int yywrap()
{
	return 1;
}
