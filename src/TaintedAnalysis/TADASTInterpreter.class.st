Class {
	#name : #TADASTInterpreter,
	#superclass : #DASTInterpreter,
	#category : #TaintedAnalysis
}

{ #category : #private }
TADASTInterpreter >> solvePrimitive: aMethod receiver: anObject arguments: anArray [

	super solvePrimitive: aMethod receiver: anObject arguments: anArray.
	(anObject isTainted or: [ 
		 anArray anySatisfy: [ :each | each isTainted ] ]) ifTrue: [ 
		self stackTop taint ]
]

{ #category : #visiting }
TADASTInterpreter >> visitLiteralArrayNode: aRBLiteralArrayNode [

	super visitLiteralArrayNode: aRBLiteralArrayNode.
	self currentContext isTainting ifTrue: [ self stackTop taint ]
	
]

{ #category : #visiting }
TADASTInterpreter >> visitLiteralNode: aRBLiteralValueNode [

	super visitLiteralNode: aRBLiteralValueNode.
	self currentContext isTainting ifTrue: [ self stackTop taint ]
]

{ #category : #visiting }
TADASTInterpreter >> visitMessageNode: aRBMessageNode [

	^ super visitMessageNode: aRBMessageNode
]

{ #category : #visiting }
TADASTInterpreter >> visitReturnNode: aRBReturnNode [

	| context conditionForTainting |
	context := self currentContext.
	conditionForTainting := context receiver isTainted or: [ 
		                        context messageNode isNotNil and: [ 
			                        context messageNode arguments anySatisfy: [ 
				                        :each | each isTainted ] ] ].
	super visitReturnNode: aRBReturnNode.
	conditionForTainting ifTrue: [ self stackTop taint ]
]
