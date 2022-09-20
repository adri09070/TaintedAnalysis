Extension { #name : #DASTContext }

{ #category : #'*TaintedAnalysis' }
DASTContext >> isTainting [

	^ receiver isTainted
]
