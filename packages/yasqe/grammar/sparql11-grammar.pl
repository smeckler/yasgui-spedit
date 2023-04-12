/*
Reduced SPARQL 1.1 grammar for SPARQL_edit
06.04.2023 S.Meckler

SPARQL 1.1 grammar rules based on the Last Call Working Draft of 24/07/2012:
  http://www.w3.org/TR/2012/WD-sparql11-query-20120724/#sparqlGrammar

Be careful with grammar notation - it is EBNF in prolog syntax!

[...] lists always represent sequence.
or can be used as binary operator or n-ary prefix term - do not put [...]
inside unless you want sequence as a single disjunct.

*, +, ? - generally used as 1-ary terms

stephen.cresswell@tso.co.uk
*/

% We need to be careful with end-of-input marker $
% Since we never actually receive this from Codemirror,
% we can't have it appear on RHS of deployed rules.
% However, we do need it to check whether rules *could* precede
% end-of-input, so use it with top-level

:-dynamic '==>'/2.

sparql11 ==> [prologue,queryAll, $].
queryUnit ==> [query,$].

query ==>
	[prologue,selectQuery,valuesClause].
queryAll ==>
	[selectQuery,valuesClause].

prologue ==>
	[*(baseDecl or prefixDecl)].

baseDecl ==>
	['BASE','IRI_REF'].

prefixDecl ==>
	['PREFIX','PNAME_NS','IRI_REF'].

% [7]
selectQuery ==>
	[selectClause,?(datasetClause),whereClause,solutionModifier].

% [9]
selectClause ==>
	['SELECT',
	?('DISTINCT' or 'REDUCED'),
	(+var or '*')].

% [13]
datasetClause ==>
	['FROM',defaultGraphClause].

defaultGraphClause ==>
	[sourceSelector].

sourceSelector ==>
	[iriRef].

% [17]
whereClause ==>
	[?('WHERE'),groupGraphPattern].

%[18]
solutionModifier ==>
	[?(orderClause),?(limitOffsetClauses)].

%[23]
orderClause ==>
	['ORDER','BY',+(orderCondition)].

orderCondition ==>
	['ASC' or 'DESC',brackettedExpression].
orderCondition ==>
	[constraint].
orderCondition ==>
	[var].

%[25]
limitOffsetClauses ==>
	[limitClause, ?(offsetClause)].
limitOffsetClauses ==>
	[offsetClause, ?(limitClause)].

%[26]
limitClause ==>
	['LIMIT','INTEGER'].

%[27]
offsetClause ==>
	['OFFSET','INTEGER'].

%[28]
valuesClause ==> ['VALUES',dataBlock].
valuesClause ==> [].

%[53]
groupGraphPattern ==>
	['{',groupGraphPatternSub,'}'].

%[54]
groupGraphPatternSub ==>
	[?(triplesBlock),*([graphPatternNotTriples,?('.'),?(triplesBlock)])].

%[55]
triplesBlock ==>
	[triplesSameSubjectPath,?(['.',?(triplesBlock)])].

%[56]
graphPatternNotTriples ==> [optionalGraphPattern].
graphPatternNotTriples ==> [filter].

%[57]
optionalGraphPattern ==> ['OPTIONAL',groupGraphPattern].

%[62]
dataBlock ==> [inlineDataOneVar or inlineDataFull].
%[63]
inlineDataOneVar ==> [var,'{',*(dataBlockValue),'}'].
%[64]
inlineDataFull ==> [ 'NIL' or ['(',*(var),')'],
                        '{',*(['(',*(dataBlockValue),')'] or 'NIL'),'}'].
%[65]
dataBlockValue ==> [iriRef].
dataBlockValue ==> [rdfLiteral].
dataBlockValue ==> [numericLiteral].
dataBlockValue ==> [booleanLiteral].
dataBlockValue ==> ['UNDEF'].

%[68]
filter ==>
	['FILTER',constraint].
%[69]
constraint ==>
	[brackettedExpression].
constraint ==>
	[builtInCall].
constraint ==>
	[functionCall].
%[70]
functionCall ==>
	[iriRef,argList].
%[70]
argList ==>
	['NIL'].
argList ==>
	['(',?('DISTINCT'),expression,*([',',expression]),')'].
%[71]
expressionList ==> ['NIL'].
expressionList ==> ['(',expression,*([',',expression]),')'].

%[75]
triplesSameSubject ==>
	[varOrTerm,propertyListNotEmpty].
triplesSameSubject ==>
	[triplesNode,propertyList].
%[76]
propertyList ==> [propertyListNotEmpty].
propertyList ==> [].
%[77]
propertyListNotEmpty ==>
	[verb,objectList,*([';',?([verb,objectList])])].
% storeProperty is a dummy for side-effect of remembering property
storeProperty==>[].
%[78]
verb ==> [storeProperty,varOrIRIref].
verb ==> [storeProperty,'a'].
%[79]
objectList ==>
	[object,*([',',object])].
%[80]
object ==>
	[graphNode].

%[81]
triplesSameSubjectPath ==> [varOrTerm,propertyListPathNotEmpty].
triplesSameSubjectPath ==> [triplesNodePath,propertyListPath].
%[82]
propertyListPath ==> [propertyListNotEmpty].
propertyListPath ==> [].
%[83] % change: verbSimple -> verb
propertyListPathNotEmpty ==>
 	[verb,
 	objectListPath,
 	*([';',?([verb,objectListPath])])].
% propertyListPathNotEmpty ==>
% 	[verbSimple,
% 	objectListPath,
% 	*([';',?([verbSimple,objectListPath])])].
% %[85]
% verbSimple ==> [var].
%[86]
objectListPath ==>
	[objectPath,*([',',objectPath])].
%[87]
objectPath ==> [graphNodePath].

%[97]
integer ==> ['INTEGER'].

%[98]
triplesNode ==> [blankNodePropertyList].

%[99]
blankNodePropertyList ==> ['[',propertyListNotEmpty,']'].

%[100]
triplesNodePath ==> [blankNodePropertyListPath].

%[101]
blankNodePropertyListPath ==> ['[',propertyListPathNotEmpty,']'].

%[104]
graphNode ==> [varOrTerm].
graphNode ==> [triplesNode].
%[105]
graphNodePath ==> [varOrTerm].
graphNodePath ==> [triplesNodePath].
%[106]
varOrTerm ==> [var].
varOrTerm ==> [graphTerm].
%[107]
varOrIRIref ==> [var].
varOrIRIref ==> [iriRef].
%[108]
var ==> ['VAR1'].
var ==> ['VAR2'].
%[109]
graphTerm ==> [iriRef].
graphTerm ==> [rdfLiteral].
graphTerm ==> [numericLiteral].
graphTerm ==> [booleanLiteral].
graphTerm ==> [blankNode].

%[110]
expression ==> [conditionalOrExpression].
%[111]
conditionalOrExpression ==>
	[conditionalAndExpression,*(['||',conditionalAndExpression])].
%[112]
conditionalAndExpression ==>
	[valueLogical,*(['&&',valueLogical])].
%[113]
valueLogical ==> [relationalExpression].
%[114]
relationalExpression ==>
	[numericExpression,
	 ?(or(['=',numericExpression],
	      ['!=',numericExpression],
	      ['<',numericExpression],
	      ['>',numericExpression],
	      ['<=',numericExpression],
	      ['>=',numericExpression],
	      ['IN',expressionList],
	      ['NOT','IN',expressionList]))].
%[115]
numericExpression ==> [additiveExpression].
%[116]
additiveExpression ==>
	[multiplicativeExpression,
	 *(or(['+',multiplicativeExpression],
	      ['-',multiplicativeExpression],
              [numericLiteralPositive or numericLiteralNegative,
	       ?(['*',unaryExpression] or ['/',unaryExpression]) ]))].
%[117]
multiplicativeExpression ==>
	[unaryExpression,*(['*',unaryExpression] or ['/',unaryExpression])].
%[118]
unaryExpression ==> ['!',primaryExpression].
unaryExpression ==> ['+',primaryExpression].
unaryExpression ==> ['-',primaryExpression].
unaryExpression ==> [primaryExpression].
%[119]
primaryExpression ==> [brackettedExpression].
primaryExpression ==> [builtInCall].
primaryExpression ==> [iriRefOrFunction].
primaryExpression ==> [rdfLiteral].
primaryExpression ==> [numericLiteral].
primaryExpression ==> [booleanLiteral].
primaryExpression ==> [var].
primaryExpression ==> [aggregate].
%[120]
brackettedExpression ==> ['(',expression,')'].
%[121]
builtInCall ==> ['STR','(',expression,')'].
builtInCall ==> ['LANG','(',expression,')'].
builtInCall ==> ['LANGMATCHES','(',expression,',',expression,')'].
builtInCall ==> ['DATATYPE','(',expression,')'].
builtInCall ==> ['BOUND','(',var,')'].
builtInCall ==> ['IRI','(',expression,')'].
builtInCall ==> ['URI','(',expression,')'].
%builtInCall ==> ['BNODE','(',?(expression),')'].  % Avoided use of NIL
%builtInCall ==> ['RAND','(',')'].                 % Avoided use of NIL
builtInCall ==> ['BNODE',['(',expression,')'] or 'NIL'].
builtInCall ==> ['RAND',['(',expression,')'] or 'NIL'].
builtInCall ==> ['ABS','(',expression,')'].
builtInCall ==> ['CEIL','(',expression,')'].
builtInCall ==> ['FLOOR','(',expression,')'].
builtInCall ==> ['ROUND','(',expression,')'].
builtInCall ==> ['CONCAT',expressionList].
builtInCall ==> [substringExpression].
builtInCall ==> ['STRLEN','(',expression,')'].
builtInCall ==> [strReplaceExpression].
builtInCall ==> ['UCASE','(',expression,')'].
builtInCall ==> ['LCASE','(',expression,')'].
builtInCall ==> ['ENCODE_FOR_URI','(',expression,')'].
builtInCall ==> ['CONTAINS','(',expression,',',expression,')'].
builtInCall ==> ['STRSTARTS','(',expression,',',expression,')'].
builtInCall ==> ['STRENDS','(',expression,',',expression,')'].
builtInCall ==> ['STRBEFORE','(',expression,',',expression,')'].
builtInCall ==> ['STRAFTER','(',expression,',',expression,')'].
builtInCall ==> ['YEAR','(',expression,')'].
builtInCall ==> ['MONTH','(',expression,')'].
builtInCall ==> ['DAY','(',expression,')'].
builtInCall ==> ['HOURS','(',expression,')'].
builtInCall ==> ['MINUTES','(',expression,')'].
builtInCall ==> ['SECONDS','(',expression,')'].
builtInCall ==> ['TIMEZONE','(',expression,')'].
builtInCall ==> ['TZ','(',expression,')'].
%builtInCall ==> ['NOW','(',')'].            % Avoided NIL
builtInCall ==> ['NOW','NIL'].
builtInCall ==> ['UUID','NIL'].
builtInCall ==> ['STRUUID','NIL'].
builtInCall ==> ['MD5','(',expression,')'].
builtInCall ==> ['SHA1','(',expression,')'].
builtInCall ==> ['SHA256','(',expression,')'].
builtInCall ==> ['SHA384','(',expression,')'].
builtInCall ==> ['SHA512','(',expression,')'].
builtInCall ==> ['COALESCE',expressionList].
builtInCall ==> ['IF','(',expression,',',expression,',',expression,')'].
builtInCall ==> ['STRLANG','(',expression,',',expression,')'].
builtInCall ==> ['STRDT','(',expression,',',expression,')'].
builtInCall ==> ['SAMETERM','(',expression,',',expression,')'].
builtInCall ==> ['ISIRI','(',expression,')'].
builtInCall ==> ['ISURI','(',expression,')'].
builtInCall ==> ['ISBLANK','(',expression,')'].
builtInCall ==> ['ISLITERAL','(',expression,')'].
builtInCall ==> ['ISNUMERIC','(',expression,')'].
builtInCall ==> [regexExpression].
builtInCall ==> [existsFunc].
builtInCall ==> [notExistsFunc].
%[122]
regexExpression ==>
	['REGEX','(',expression,',',expression,?([',',expression]),')'].
%[123]
substringExpression ==>
	['SUBSTR','(',expression,',',expression,?([',',expression]),')'].
%[124]
strReplaceExpression ==>
	['REPLACE','(',expression,',',expression,',',expression,?([',',expression]),')'].
%[125]
existsFunc ==>
	['EXISTS',groupGraphPattern].
%[126]
notExistsFunc ==>
	['NOT','EXISTS',groupGraphPattern].
%[127]
aggregate ==> ['COUNT','(',?('DISTINCT'),'*' or expression,')'].
aggregate ==> ['SUM','(',?('DISTINCT'),expression,')'].
aggregate ==> ['MIN','(',?('DISTINCT'),expression,')'].
aggregate ==> ['MAX','(',?('DISTINCT'),expression,')'].
aggregate ==> ['AVG','(',?('DISTINCT'),expression,')'].
aggregate ==> ['SAMPLE','(',?('DISTINCT'),expression,')'].
aggregate ==>
	['GROUP_CONCAT','(',
	 ?('DISTINCT'),
	 expression,
	 ?([';','SEPARATOR','=',string]),
	 ')'].
%[128]
iriRefOrFunction ==> [iriRef,?(argList)].
%[129]
rdfLiteral ==> [string,?('LANGTAG' or ['^^',iriRef])].
%[130]
numericLiteral ==> [numericLiteralUnsigned].
numericLiteral ==> [numericLiteralPositive].
numericLiteral ==> [numericLiteralNegative].
%[131]
numericLiteralUnsigned ==> ['INTEGER'].
numericLiteralUnsigned ==> ['DECIMAL'].
numericLiteralUnsigned ==> ['DOUBLE'].
%[132]
numericLiteralPositive ==> ['INTEGER_POSITIVE'].
numericLiteralPositive ==> ['DECIMAL_POSITIVE'].
numericLiteralPositive ==> ['DOUBLE_POSITIVE'].
%[133]
numericLiteralNegative ==> ['INTEGER_NEGATIVE'].
numericLiteralNegative ==> ['DECIMAL_NEGATIVE'].
numericLiteralNegative ==> ['DOUBLE_NEGATIVE'].
%[134]
booleanLiteral ==> ['TRUE'].
booleanLiteral ==> ['FALSE'].
%[135]
string ==> ['STRING_LITERAL1'].
string ==> ['STRING_LITERAL2'].
string ==> ['STRING_LITERAL_LONG1'].
string ==> ['STRING_LITERAL_LONG2'].
%[136]
iriRef ==> ['IRI_REF'].
iriRef ==> [prefixedName].
%[137]
prefixedName ==> ['PNAME_LN'].
prefixedName ==> ['PNAME_NS'].
%[138]
blankNode ==> ['BLANK_NODE_LABEL'].
blankNode ==> ['ANON'].


% tokens defined by regular expressions elsewhere
tm_regex([

'IRI_REF',

'VAR1',
'VAR2',
'LANGTAG',

'DOUBLE',
'DECIMAL',
'INTEGER',
'DOUBLE_POSITIVE',
'DECIMAL_POSITIVE',
'INTEGER_POSITIVE',
'INTEGER_NEGATIVE',
'DECIMAL_NEGATIVE',
'DOUBLE_NEGATIVE',

'STRING_LITERAL_LONG1',
'STRING_LITERAL_LONG2',
'STRING_LITERAL1',
'STRING_LITERAL2',

'NIL',
'ANON',
'PNAME_LN',
'PNAME_NS',
'BLANK_NODE_LABEL'
]).

% Terminals where name of terminal is uppercased token content
tm_keywords([

'GROUP_CONCAT', % Must appear before GROUP
'DATATYPE',     % Must appear before DATA

'BASE',
'PREFIX',
'SELECT',
'CONSTRUCT',
'DESCRIBE',
'ASK',
'FROM',
'NAMED',
'ORDER',
'BY',
'LIMIT',
'ASC',
'DESC',
'OFFSET',
'DISTINCT',
'REDUCED',
'WHERE',
'GRAPH',
'OPTIONAL',
'UNION',
'FILTER',
'GROUP',
'HAVING',
'AS',
'VALUES',
'LOAD',
'CLEAR',
'DROP',
'CREATE',
'MOVE',
'COPY',
'SILENT',
'INSERT',
'DELETE',
'DATA',
'WITH',
'TO',
'USING',
'NAMED',
'MINUS',
'BIND',

'LANGMATCHES',
'LANG',
'BOUND',
'SAMETERM',
'ISIRI',
'ISURI',
'ISBLANK',
'ISLITERAL',
'REGEX',
'TRUE',
'FALSE',

'UNDEF',
'ADD',
'DEFAULT',
'ALL',
'SERVICE',
'INTO',
'IN',
'NOT',
'IRI',
'URI',
'BNODE',
'RAND',
'ABS',
'CEIL',
'FLOOR',
'ROUND',
'CONCAT',
'STRLEN',
'UCASE',
'LCASE',
'ENCODE_FOR_URI',
'CONTAINS',
'STRSTARTS',
'STRENDS',
'STRBEFORE',
'STRAFTER',
'YEAR',
'MONTH',
'DAY',
'HOURS',
'MINUTES',
'SECONDS',
'TIMEZONE',
'TZ',
'NOW',
'UUID',
'STRUUID',
'MD5',
'SHA1',
'SHA256',
'SHA384',
'SHA512',
'COALESCE',
'IF',
'STRLANG',
'STRDT',
'ISNUMERIC',
'SUBSTR',
'REPLACE',
'EXISTS',
'COUNT',
'SUM',
'MIN',
'MAX',
'AVG',
'SAMPLE',
'SEPARATOR',

'STR'
]).

% Other tokens representing fixed, case sensitive, strings
% Care! order longer tokens first - e.g. IRI_REF, <=, <
% e.g. >=, >
% e.g. NIL, '('
% e.g. ANON, [
% e.g. DOUBLE, DECIMAL, INTEGER
% e.g. INTEGER_POSITIVE, PLUS
tm_punct([
'*'= '\\*',
'a'= 'a',
'.'= '\\.',
'{'= '\\{',
'}'= '\\}',
','= ',',
'('= '\\(',
')'= '\\)',
';'= ';',
'['= '\\[',
']'= '\\]',
'||'= '\\|\\|',
'&&'= '&&',
'='= '=',
'!='= '!=',
'!'= '!',
'<='= '<=',
'>='= '>=',
'<'= '<',
'>'= '>',
'+'= '\\+',
'-'= '-',
'/'= '\\/',
'^^'= '\\^\\^',
'?' = '\\?',
'|' = '\\|',
'^'= '\\^'
]).
