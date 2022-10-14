"
To load:

```language=Pharo
Metacello new
	repository: 'github://adri09070/TaintedAnalysis:wrapper';
	baseline: 'TaintedAnalysis';
	load
```
"
Class {
	#name : #BaselineOfTaintedAnalysis,
	#superclass : #BaselineOf,
	#category : #BaselineOfTaintedAnalysis
}

{ #category : #baselines }
BaselineOfTaintedAnalysis >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Dependencies"
		spec baseline: 'DebuggableASTInterpreter' with: [ 
			spec
				loads: 'Debugger';
				repository:
					'github://adri09070/DebuggableASTInterpreter:14-Program-termination-is-not-checked-OR-tested-correctly' ].

		"Packages"
		spec
			package: 'TaintedAnalysis'
			with: [ spec requires: #( 'DebuggableASTInterpreter' ) ];
			package: 'TaintedAnalysisTests'
			with: [ spec requires: #( 'TaintedAnalysis' ) ] ].

	"Groups"
	spec
		group: 'default' with: #( 'TaintedAnalysis' );
		group: 'withTests' with: #( 'TaintedAnalysisTests' )
]
