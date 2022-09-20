Class {
	#name : #TaintedAnalysisTests,
	#superclass : #TestCase,
	#instVars : [
		'oldTainted',
		'obj1'
	],
	#category : #TaintedAnalysisTests
}

{ #category : #running }
TaintedAnalysisTests >> setUp [

	super setUp.
	obj1 := TAClassForTests new.
	oldTainted := TaintManager defaultInstance taintedSet

	"Put here a common initialization logic for tests"
]

{ #category : #running }
TaintedAnalysisTests >> tearDown [

	super tearDown.
	TaintManager defaultInstance taintedSet: oldTainted
]

{ #category : #tests }
TaintedAnalysisTests >> testTaintedAddition [

	| a interpreter c context |
	interpreter := TADASTInterpreter new.
	interpreter initializeWithProgram:
		(RBParser parseExpression: ' | a b c |
			a := 1.
			a taint. 
			b := 2. 
			c := a + b ').

	7 timesRepeat: [ interpreter stepOver ].

	context := interpreter currentContext.

	a := interpreter currentContext findVariable: #a.

	self assert: a isTainted.

	interpreter evaluate.

	c := context findVariable: #c.

	self assert: c isTainted
]

{ #category : #tests }
TaintedAnalysisTests >> testTaintedObjectCopyIsTainted [

	| copyObj interpreter context |
	interpreter := TADASTInterpreter new.
	interpreter initializeWithProgram:
		(RBParser parseExpression: ' | obj1 copyObj |

	obj1 taint.
	
	copyObj := obj1 copy.').

	context := interpreter currentContext.

	interpreter evaluate.

	copyObj := context findVariable: #copyObj.

	self assert: copyObj isTainted
]

{ #category : #tests }
TaintedAnalysisTests >> testTaintedObjectWriteOnOtherObjectWithLiteralArray [

	| obj2 interpreter |
	interpreter := TADASTInterpreter new.
	interpreter initializeWithProgram:
		(RBParser parseExpression: ' | obj1 obj2 |
			obj1 := TAClassForTests new. 
			obj1 taint. 
			obj2 := TAClassForTests new. 
			obj1 writesFooWithLiteralArrayOf: obj2. ').

	10 timesRepeat: [ interpreter stepOver ].

	obj2 := interpreter currentContext findVariable: #obj2.

	interpreter evaluate.

	self deny: obj2 isTainted.

	self assert: obj2 foo isTainted.
	obj2 foo do: [ :each | self assert: each isTainted ]
]

{ #category : #tests }
TaintedAnalysisTests >> testTaintedObjectWriteOnOtherObjectWithLiteralValue [

	| obj2 interpreter |
	interpreter := TADASTInterpreter new.
	interpreter initializeWithProgram:
		(RBParser parseExpression: ' | obj1 obj2 |
			obj1 := TAClassForTests new. 
			obj1 taint. 
			obj2 := TAClassForTests new. 
			obj1 writesFooOf: obj2. ').

	10 timesRepeat: [ interpreter stepOver ].

	obj2 := interpreter currentContext findVariable: #obj2.

	interpreter evaluate.

	self deny: obj2 isTainted.

	self assert: obj2 foo isTainted
]

{ #category : #tests }
TaintedAnalysisTests >> testTaintedObjectWriteOnOtherObjectWithNewObject [

	| obj2 interpreter |
	interpreter := TADASTInterpreter new.
	interpreter initializeWithProgram:
		(RBParser parseExpression: ' | obj1 obj2 |
			obj1 := TAClassForTests new. 
			obj1 taint. 
			obj2 := TAClassForTests new. 
			obj1 writesFooWithNewObjectOf: obj2. ').

	10 timesRepeat: [ interpreter stepOver ].

	obj2 := interpreter currentContext findVariable: #obj2.

	interpreter evaluate.
	
	self deny: obj2 isTainted.

	self assert: obj2 foo isTainted
]

{ #category : #tests }
TaintedAnalysisTests >> testTaints [

	self deny: obj1 isTainted.

	obj1 taint.

	self assert: obj1 isTainted
]

{ #category : #tests }
TaintedAnalysisTests >> testTaintsWithInstanceVariable [

	obj1 foo: Object new.

	self deny: obj1 isTainted.
	self deny: obj1 foo isTainted.

	obj1 taint.

	self assert: obj1 isTainted.
	self assert: obj1 foo isTainted
]

{ #category : #tests }
TaintedAnalysisTests >> testTaintsWithSpecificManager [

	| manager |
	manager := TaintManager new.

	self deny: (obj1 isTaintedWithManager: manager).

	obj1 taintWithManager: manager.

	self assert: (obj1 isTaintedWithManager: manager)
]
