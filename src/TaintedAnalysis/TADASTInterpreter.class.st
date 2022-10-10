Class {
	#name : #TADASTInterpreter,
	#superclass : #DASTInterpreter,
	#category : #TaintedAnalysis
}

{ #category : #visiting }
TADASTInterpreter >> readInstanceVariableNamed: name [

	"Pb : self receveiver in DASTBlockContext looks to the outerContext receiver. If block context we want to swap the receiver of the outer context."

	| wrappedReceiver value context |
	self currentContext isBlockContext
		ifTrue: [ context := self currentContext parent ]
		ifFalse: [ context := self currentContext ].
	wrappedReceiver := context receiver.
	context receiver: wrappedReceiver wrappedObject.
	value := (context findInstanceVariable: name) value.
	context receiver: wrappedReceiver.
	^ value
]

{ #category : #private }
TADASTInterpreter >> solvePrimitive: aMethod receiver: anObject arguments: anArray [

	super solvePrimitive: aMethod receiver: anObject arguments: anArray.
	"(anObject isTainted or: [ 
		 anArray anySatisfy: [ :each | each isTainted ] ]) ifTrue: [ 
		self stackTop taint ]"
]

{ #category : #visiting }
TADASTInterpreter >> visitAssignmentNode: aRBAssignmentNode [

	| name value wrappedReceiver |
	name := aRBAssignmentNode variable name.
	value := self stackTop.
	wrappedReceiver := currentContext receiver.
	self currentContext receiver: wrappedReceiver wrappedObject.
	self currentContext assignVariable: name value: value.
	self currentContext receiver: wrappedReceiver
]

{ #category : #visiting }
TADASTInterpreter >> visitGlobalNode: aRBGlobalNode [

	| globalValue |
	globalValue := currentContext findVariable: aRBGlobalNode name.
	self stackPush: (globalValue isWrapper
			 ifFalse: [ TaintWrapper on: globalValue ]
			 ifTrue: [ globalValue ])
]

{ #category : #visiting }
TADASTInterpreter >> visitLiteralArrayNode: aRBLiteralArrayNode [

	super visitLiteralArrayNode: aRBLiteralArrayNode.
	"self currentContext isTainting ifTrue: [ self stackTop taint ]"
	
]

{ #category : #visiting }
TADASTInterpreter >> visitLiteralNode: aRBLiteralValueNode [

	| wrapper |
	wrapper := TaintWrapper on: aRBLiteralValueNode value.
	self stackPush: wrapper
]

{ #category : #visiting }
TADASTInterpreter >> visitMessageNode: aRBMessageNode [

	| arguments wrappedReceiver receiver method newContext primitiveResult |
	" Resolve Arguments "
	"self haltIf: [ aRBMessageNode selector = #isPoint ]."
	arguments := (self stackPop: aRBMessageNode numArgs) reverse.
	(aRBMessageNode isCascaded and: [ aRBMessageNode isFirstCascaded not ]) 
		ifTrue: [ self stackPop ].
	receiver := self stackPop.
	wrappedReceiver := receiver.

	aRBMessageNode selector = #taint ifFalse: [ 
		receiver := receiver wrappedObject ].

	" Current context initialization (implicit lookup)"
	newContext := DASTContext
		              newWithSender: self currentContext
		              receiver: receiver
		              messageNode: aRBMessageNode
		              evaluator: self evaluator.

	" Lookup"
	method := newContext methodOrBlock.
	" Apply - invoke method "
	(aRBMessageNode isCascaded and: [ 
		 aRBMessageNode parent messages last ~= aRBMessageNode ]) ifTrue: [ 
		self stackPush: receiver ].
	(method isPrimitive and: [ 
		 method isMessageValue not and: [ method isOnDo not ] ]) ifTrue: [ 
		[ 
		primitiveResult := (self
			                    solvePrimitive: method
			                    receiver: receiver
			                    arguments:
			                    (arguments collect: [ :argument | 
				                     argument wrappedObject ])) stackPop.
		primitiveResult := TaintWrapper on: primitiveResult.
		primitiveResult addTaintFrom: wrappedReceiver.
		arguments do: [ :arg | primitiveResult addTaintFrom: arg ].
		self stackPush: primitiveResult.
		^ self ]
			on: DASTPrimitiveFailed
			do: [ " Remove pragma node from method body to prevent infinit loop 
			  and continue with the excecution of the method body"
				newContext := newContext
					              removePrimitiveFromMethod;
					              yourself ] ].
	" Set new context "
	currentContext := newContext.
	currentContext
		setTemporalVariablesNamed: method argumentNames values: arguments;
		receiver: wrappedReceiver
]

{ #category : #visiting }
TADASTInterpreter >> visitReturnNode: aRBReturnNode [

	| context conditionForTainting |
	context := self currentContext.
	conditionForTainting := context receiver isTainted.
	super visitReturnNode: aRBReturnNode.
	conditionForTainting ifTrue: [ 
		self stackTop addTaintFrom: context receiver ]
]
