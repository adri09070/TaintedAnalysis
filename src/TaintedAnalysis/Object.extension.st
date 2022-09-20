Extension { #name : #Object }

{ #category : #'*TaintedAnalysis' }
Object >> isTainted [

	^ self isTaintedWithManager: TaintManager defaultInstance
]

{ #category : #'*TaintedAnalysis' }
Object >> isTaintedWithManager: aTaintManager [ 

	^ aTaintManager hasObjectTainted: self
]

{ #category : #'*TaintedAnalysis' }
Object >> taint [

	^ self taintWithManager: TaintManager defaultInstance
]

{ #category : #'*TaintedAnalysis' }
Object >> taintWithManager: aTaintManager [ 

	aTaintManager addTainted: self
]

{ #category : #'*TaintedAnalysis' }
Object >> untaint [

	^ self untaintWithManager: TaintManager defaultInstance
]
