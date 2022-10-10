Extension { #name : #Object }

{ #category : #'*TaintedAnalysis' }
Object >> isTainted [

	^ false
]

{ #category : #'*TaintedAnalysis' }
Object >> isWrapper [

	^ false
]

{ #category : #'*TaintedAnalysis' }
Object >> taValue [

	^ self
]

{ #category : #'*TaintedAnalysis' }
Object >> taintWrap [

	| wrapper |
	wrapper := TaintWrapper new.
	^ wrapper
		  target: self;
		  yourself
]

{ #category : #'*TaintedAnalysis' }
Object >> wrappedObject [

	^ self
]
