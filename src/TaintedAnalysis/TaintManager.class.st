Class {
	#name : #TaintManager,
	#superclass : #Object,
	#instVars : [
		'taintedSet'
	],
	#classVars : [
		'DefaultInstance'
	],
	#category : #TaintedAnalysis
}

{ #category : #'as yet unclassified' }
TaintManager class >> defaultInstance [

	^ DefaultInstance ifNil: [ DefaultInstance := self new ]
]

{ #category : #tainting }
TaintManager >> addTainted: anObject [

	taintedSet add: anObject.
	"anObject class allInstVarNames do: [ :each | self addTainted: (anObject instVarNamed: each ) ]"
]

{ #category : #querying }
TaintManager >> hasObjectTainted: anObject [ 

	^ self taintedSet includes: anObject
]

{ #category : #initialization }
TaintManager >> initialize [

	taintedSet := WeakIdentitySet new
]

{ #category : #'adding-removing' }
TaintManager >> removeTainted: anObject [

	taintedSet remove: anObject
]

{ #category : #accessing }
TaintManager >> taintedSet [

	^ taintedSet copy
]

{ #category : #accessing }
TaintManager >> taintedSet: aWeakIdentitySet [

	taintedSet := aWeakIdentitySet
]
