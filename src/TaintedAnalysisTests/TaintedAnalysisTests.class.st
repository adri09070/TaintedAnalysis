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
TaintedAnalysisTests >> testTaintedObjectCopyIsTainted [

	| copyObj |

	obj1 taint.
	
	copyObj := obj1 copy.
	
	self assert: copyObj isTainted

]

{ #category : #tests }
TaintedAnalysisTests >> testTaintedObjectWriteOnOtherObject [

	| obj2 interpreter |
	interpreter := DASTInterpreter new.
	interpreter initializeWithProgram:
		(RBParser parseExpression: ' | obj1 obj2 |
			obj1 := TAClassForTests new. 
			obj1 taint. 
			obj2 := TAClassForTests new. 
			obj1 writesObjectOf: obj2. ').

	10 timesRepeat: [ interpreter stepOver ].

	obj2 := interpreter currentContext findVariable: #obj2.

	self deny: obj2 isTainted.

	interpreter evaluate.

	self assert: obj2 isTainted
]

{ #category : #tests }
TaintedAnalysisTests >> testTaints [

	self deny: obj1 isTainted.

	obj1 taint.

	self assert: obj1 isTainted
]

{ #category : #tests }
TaintedAnalysisTests >> testTaintsWithSpecificManager [

	| manager |
	manager := TaintManager new.

	self deny: (obj1 isTaintedWithManager: manager).

	obj1 taintWithManager: manager.

	self assert: (obj1 isTaintedWithManager: manager)
]
