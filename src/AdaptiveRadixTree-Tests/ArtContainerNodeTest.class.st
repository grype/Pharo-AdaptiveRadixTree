Class {
	#name : #ArtContainerNodeTest,
	#superclass : #TestCase,
	#category : #'AdaptiveRadixTree-Tests-Core'
}

{ #category : #tests }
ArtContainerNodeTest >> testSplitAtPrefixIndexDepth [
	| node |

	node := ArtNode4 new.
	node prefix: 'an' asByteArray.
	node prefixSize: 2.
	node splitAtPrefixIndex: 2 depth: 1.
	node should beKindOf: ArtNode4.
	node prefix should equal: 'a' asByteArray.
	node prefixSize should equal: 1.

	node := ArtNode4 new.
	node prefix: 'an' asByteArray.
	node prefixSize: 2.
	node splitAtPrefixIndex: 1 depth: 1.
	node should beKindOf: ArtNode4.
	node prefixSize should equal: 0.

	node := ArtNode4 new.
	node prefix: 'anddd' asByteArray.
	node prefixSize: 2.
	node splitAtPrefixIndex: 2 depth: 1.
	node should beKindOf: ArtNode4.
	node prefix should equal: 'a' asByteArray.
	node prefixSize should equal: 1.
	
	node := ArtNode4 new.
	node prefix: 'an' asByteArray.
	node prefixSize: 2.
	node splitAtPrefixIndex: 2 depth: 100.
	node should beKindOf: ArtNode4.
	node prefix should equal: 'a' asByteArray.
	node prefixSize should equal: 1.
	
	node := ArtNode16 new.
	node prefix: 'anddd' asByteArray.
	node prefixSize: 2.
	node splitAtPrefixIndex: 2 depth: 1.
	node should beKindOf: ArtNode4.
	node prefix should equal: 'a' asByteArray.
	node prefixSize should equal: 1.
	

	node := ArtNode4 new.
	node prefix: 'abcdefghij' asByteArray.
	node prefixSize: 12.
	node children at: 1 put: (ArtLeafNode key: 'abcdefghijkl' value: 'End node').
	node splitAtPrefixIndex: 2 depth: 1.
	node should beKindOf: ArtNode4.
	node prefix should equal: 'a' asByteArray.
	node prefixSize should equal: 1.
]

{ #category : #tests }
ArtContainerNodeTest >> testprefixMismatchWithDepth [
	| node key |

	key := 'abc' asByteArray ensureNullTerminated.
	node := ArtNode4 new.

	node
		prefix: 'a' asByteArray;
		prefixSize: 1.
	(node prefixMismatchWith: key depth: 1) should equal: 2.

	node
		prefix: 'b' asByteArray;
		prefixSize: 1.
	(node prefixMismatchWith: key depth: 2) should equal: 2.
	
	node
		prefix: 'ab' asByteArray;
		prefixSize: 2.
	(node prefixMismatchWith: key depth: 1) should equal: 3.
	
	node
		prefix: 'z' asByteArray;
		prefixSize: 1.
	(node prefixMismatchWith: key depth: 1) should equal: 1.
	
	node
		prefix: 'zzz' asByteArray;
		prefixSize: 3.
	(node prefixMismatchWith: key depth: 1) should equal: 1.
	
	node
		prefix: 'abc' asByteArray;
		prefixSize: 3.
	(node prefixMismatchWith: key depth: 1) should equal: 4.
	
	node
		prefix: 'bc' asByteArray;
		prefixSize: 1.
	(node prefixMismatchWith: key depth: 2) should equal: 2.
]
