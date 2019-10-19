Class {
	#name : #ArtContainerNodeTest,
	#superclass : #TestCase,
	#category : #'AdaptiveRadixTree-Tests-Core'
}

{ #category : #tests }
ArtContainerNodeTest >> testSplitAtPrefixIndexDepth [
	| node4 firstLeaf secondLeaf |

	node4 := ArtNode node4.
	node4 prefix: 'an'.
	node4 prefixSize: 2.

	node4 at: 'and' asByteArray put: 'And' depth: 1.
	node4 size should equal: 1.
	firstLeaf := ArtNode leafWithKey: 'and' asByteArray value: 'And'.
	node4 children first should equal: firstLeaf.

	node4 at: 'art' asByteArray put: 'Art' depth: 1.
	node4 size should equal: 2.
	node4 children first should beKindOf: ArtNode4.
	node4 children first size should equal: 1.
	node4 children first children first should equal: firstLeaf.
	secondLeaf := ArtNode leafWithKey: 'art' value: 'Art'.
	node4 children second should equal: secondLeaf
]
