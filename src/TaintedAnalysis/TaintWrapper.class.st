Class {
	#name : #TaintWrapper,
	#superclass : #Object,
	#instVars : [
		'wrappedObject',
		'taintInfo'
	],
	#category : #TaintedAnalysis
}

{ #category : #'instance creation' }
TaintWrapper class >> on: anObject [

	^ self new
		  wrappedObject: anObject;
		  yourself
]

{ #category : #tainting }
TaintWrapper >> addTaintFrom: aTaintWrapper [ 
	taintInfo addAll: aTaintWrapper taintInfo .
]

{ #category : #testing }
TaintWrapper >> initialize [ 
	super initialize.
	taintInfo := Set new.
]

{ #category : #testing }
TaintWrapper >> isTainted [

	^ taintInfo isNotEmpty 
]

{ #category : #testing }
TaintWrapper >> isWrapper [

	^ true
]

{ #category : #printing }
TaintWrapper >> printOn: aStream [
	aStream nextPut: $/.
	wrappedObject printOn: aStream.
	aStream nextPut: $/.
	taintInfo ifNotEmpty: [ aStream nextPut:$* ]
]

{ #category : #accessing }
TaintWrapper >> taValue [

	^ self wrappedObject
]

{ #category : #'as yet unclassified' }
TaintWrapper >> taint [

	taintInfo := #tainted
]

{ #category : #accessing }
TaintWrapper >> taintInfo [

	^ taintInfo
]

{ #category : #accessing }
TaintWrapper >> taintInfo: anObject [

	taintInfo := anObject
]

{ #category : #accessing }
TaintWrapper >> wrappedObject [

	^ wrappedObject
]

{ #category : #accessing }
TaintWrapper >> wrappedObject: anObject [

	wrappedObject := anObject
]
