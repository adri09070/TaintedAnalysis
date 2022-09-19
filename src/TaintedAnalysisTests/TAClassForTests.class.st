Class {
	#name : #TAClassForTests,
	#superclass : #Object,
	#instVars : [
		'object'
	],
	#category : #TaintedAnalysisTests
}

{ #category : #accessing }
TAClassForTests >> object [

	^ object
]

{ #category : #accessing }
TAClassForTests >> object: anObject [

	object := anObject
]

{ #category : #helper }
TAClassForTests >> writesObjectOf: aTAClassForTests [

	aTAClassForTests object: 42
]
