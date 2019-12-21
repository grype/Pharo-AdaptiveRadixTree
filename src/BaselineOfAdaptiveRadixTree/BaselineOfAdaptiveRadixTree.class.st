Class {
	#name : #BaselineOfAdaptiveRadixTree,
	#superclass : #BaselineOf,
	#category : #BaselineOfAdaptiveRadixTree
}

{ #category : #baselines }
BaselineOfAdaptiveRadixTree >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [ self roassal: spec.
			spec
				package: 'AdaptiveRadixTree';
				package: 'AdaptiveRadixTree-Tests'
					with: [ spec requires: #('AdaptiveRadixTree') ];
				package: 'AdaptiveRadixTree-Tools'
					with: [ spec requires: #('AdaptiveRadixTree' 'Roassal2') ].

			spec
				group: 'Core' with: #(#AdaptiveRadixTree);
				group: 'Tests'
					with: #('AdaptiveRadixTree' #'AdaptiveRadixTree-Tests');
				group: 'Tools'
					with: #('AdaptiveRadixTree' #'AdaptiveRadixTree-Tools');
				group: 'default' with: #(#Core 'Tests' 'Tools') ]
]

{ #category : #baselines }
BaselineOfAdaptiveRadixTree >> roassal: spec [
	spec
		baseline: 'Roassal2'
		with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ]
]
