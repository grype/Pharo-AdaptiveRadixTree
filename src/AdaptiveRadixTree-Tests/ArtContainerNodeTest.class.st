Class {
	#name : #ArtContainerNodeTest,
	#superclass : #TestCase,
	#category : #'AdaptiveRadixTree-Tests-Core'
}

{ #category : #tests }
ArtContainerNodeTest >> testSplitAtPrefixIndexDepth [
	| node parent newNode leaf |

	parent := ArtTree new.

	node := ArtNode4 new.
	node parent: parent.
	node prefix: 'an' asByteArray.
	node prefixSize: 2.
	newNode := node splitAtPrefixIndex: 2 depth: 1.
	newNode should beKindOf: ArtNode4.
	newNode parent should be: parent.
	node parent should be: newNode.
	(newNode prefix copyFrom: 1 to: newNode prefixSize) should equal: 'a' asByteArray.
	newNode prefixSize should equal: 1.
	node prefixSize should equal: 0.

	node := ArtNode4 new.
	node parent: parent.
	node prefix: 'an' asByteArray.
	node prefixSize: 2.
	newNode := node splitAtPrefixIndex: 1 depth: 1.
	newNode should beKindOf: ArtNode4.
	newNode prefixSize should equal: 0.
	(newNode keys at: 1) should equal: $a asInteger.
	node prefixSize should equal: 1.
	(node prefix at: 1) should equal: $n asInteger.

	node := ArtNode4 new.
	node parent: parent.
	node prefix: 'anddd' asByteArray.
	node prefixSize: 2.
	newNode := node splitAtPrefixIndex: 2 depth: 1.
	newNode should beKindOf: ArtNode4.
	(newNode prefix copyFrom: 1 to: newNode prefixSize) should equal: 'a' asByteArray.
	newNode prefixSize should equal: 1.
	node prefixSize should equal: 0.

	node := ArtNode4 new.
	node parent: parent.
	node prefix: 'an' asByteArray.
	node prefixSize: 2.
	newNode := node splitAtPrefixIndex: 2 depth: 100.
	newNode should beKindOf: ArtNode4.
	(newNode prefix copyFrom: 1 to: newNode prefixSize) should equal: 'a' asByteArray.
	newNode prefixSize should equal: 1.
	node prefixSize should equal: 0.

	node := ArtNode16 new.
	node parent: parent.
	node prefix: 'anddd' asByteArray.
	node prefixSize: 2.
	newNode := node splitAtPrefixIndex: 2 depth: 1.
	newNode should beKindOf: ArtNode4.
	(newNode prefix copyFrom: 1 to: newNode prefixSize) should equal: 'a' asByteArray.
	newNode prefixSize should equal: 1.
	node prefixSize should equal: 0.

	leaf := ArtLeafNode new
		key: 'abcdefghijkl' asByteArray nullTerminated;
		value: 'End node';
		yourself.
	node := ArtNode4 new.
	node parent: parent.
	node prefix: (leaf key asByteArray first: ArtNode4 maxPrefixSize).
	node prefixSize: 11.
	node keys at: 1 put: (leaf key at: 12).
	node children at: 1 put: leaf.
	newNode := node splitAtPrefixIndex: 2 depth: 1.
	newNode should beKindOf: ArtNode4.
	(newNode prefix copyFrom: 1 to: newNode prefixSize) should equal: 'a' asByteArray.
	newNode prefixSize should equal: 1.
	(newNode keys at: 1) should equal: (leaf key at: 2).
	node prefixSize should equal: 9.
	(node prefix first: 9) should
		equal: (leaf key copyFrom: 3 to: leaf key size - 2)
]

{ #category : #tests }
ArtContainerNodeTest >> testprefixMismatchWithDepth [
	| node key |

	key := 'abc' asByteArray nullTerminated.
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
