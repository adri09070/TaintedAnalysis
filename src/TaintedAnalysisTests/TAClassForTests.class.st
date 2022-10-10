Class {
	#name : #TAClassForTests,
	#superclass : #Object,
	#instVars : [
		'foo'
	],
	#category : #TaintedAnalysisTests
}

{ #category : #accessing }
TAClassForTests >> foo [

	^ foo
]

{ #category : #accessing }
TAClassForTests >> foo: anObject [

	foo := anObject
]

{ #category : #helper }
TAClassForTests >> writesFooOf: aTAClassForTests [

	aTAClassForTests foo: 42
]

{ #category : #helper }
TAClassForTests >> writesFooOf: aFirstObj withFooFrom: aSecondObj [

	aFirstObj foo: aSecondObj foo
]

{ #category : #helper }
TAClassForTests >> writesFooWithLiteralArrayOf: aTAClassForTests [

	aTAClassForTests foo: #(1 2 3)
]

{ #category : #helper }
TAClassForTests >> writesFooWithNewObjectOf: aTAClassForTests [

	aTAClassForTests foo: Object new
]
