Class {
	#name : #BaselineOfAdaptiveRadixTree,
	#superclass : #BaselineOf,
	#category : #BaselineOfAdaptiveRadixTree
}

{ #category : #baselines }
BaselineOfAdaptiveRadixTree >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: 'AdaptiveRadixTree';
			package: 'AdaptiveRadixTree-Tests'
			with: [ spec requires: #( 'AdaptiveRadixTree' ) ].

		spec
			group: 'Core' with: #( #AdaptiveRadixTree );
			group: 'Tests'
			with: #( 'AdaptiveRadixTree' #'AdaptiveRadixTree-Tests' );
			group: 'default' with: #( #Core 'Tests' ) ]
]
