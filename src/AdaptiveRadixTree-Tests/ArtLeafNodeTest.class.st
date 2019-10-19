Class {
	#name : #ArtLeafNodeTest,
	#superclass : #TestCase,
	#category : #'AdaptiveRadixTree-Tests-Core'
}

{ #category : #tests }
ArtLeafNodeTest >> testAtPutDepth [
	self testPutAtStart.
	self testPutAtMiddle.
	self testPutAtEnd
]

{ #category : #tests }
ArtLeafNodeTest >> testInitializeWithKeyValue [
	| node |
	node := ArtLeafNode key: 'def' value: 'DEF'.
	node key should equal: 'def' asByteArray.
	node value should equal: 'DEF'
]

{ #category : #tests }
ArtLeafNodeTest >> testMatchesKey [
	| node |

	node := ArtLeafNode key: 'hello' value: 'world'.
	(node matchesKey: 'hello') should be: true.
	(node matchesKey: ' hello') should be: false.
	(node matchesKey: 'h') should be: false.
	(node matchesKey: '') should be: false
]

{ #category : #tests }
ArtLeafNodeTest >> testPutAtEnd [
	| node leaf2 leaf1 |

	node := ArtLeafNode
		key: 'abc' asByteArray ensureNullTerminated
		value: 'ABC'.
	leaf1 := node copy.
	leaf2 := ArtLeafNode
		key: 'abcd' asByteArray ensureNullTerminated
		value: 'abcd'.

	node at: leaf2 key put: leaf2 value depth: 1.
	node should beKindOf: ArtNode4.
	node size should equal: 2.

	(node children select: [ :each | each isNotNil ]) size should
		equal: 2.
	node children first should equal: leaf1.
	node children second should equal: leaf2.

	node prefix should equal: 'abc' asByteArray.
	node prefixSize should equal: 3.

	(node keys at: 1) should equal: leaf1 key fourth.
	(node children at: 1) should equal: leaf1.

	(node keys at: 2) should equal: leaf2 key fourth.
	(node children at: 2) should equal: leaf2
]

{ #category : #tests }
ArtLeafNodeTest >> testPutAtMiddle [
	| node leaf2 leaf1 |

	node := ArtLeafNode
		key: 'abc' asByteArray ensureNullTerminated
		value: 'ABC'.
	leaf1 := node copy.
	leaf2 := ArtLeafNode
		key: 'abd' asByteArray ensureNullTerminated
		value: 'ABD'.

	node at: leaf2 key put: leaf2 value depth: 1.
	node should beKindOf: ArtNode4.
	node size should equal: 2.

	(node children select: [ :each | each isNotNil ]) size should
		equal: 2.
	node children first should equal: leaf1.
	node children second should equal: leaf2.

	node prefix should equal: 'ab' asByteArray.
	node prefixSize should equal: 2.

	(node keys at: 1) should equal: leaf1 key third.
	(node children at: 1) should equal: leaf1.

	(node keys at: 2) should equal: leaf2 key third.
	(node children at: 2) should equal: leaf2
]

{ #category : #tests }
ArtLeafNodeTest >> testPutAtStart [
	| node leaf2 leaf1 |

	node := ArtLeafNode
		key: 'abc' asByteArray ensureNullTerminated
		value: 'ABC'.
	leaf1 := node copy.
	leaf2 := ArtLeafNode
		key: 'def' asByteArray ensureNullTerminated
		value: 'DEF'.

	node at: leaf2 key put: leaf2 value depth: 1.
	node should beKindOf: ArtNode4.
	node size should equal: 2.

	(node children select: [ :each | each isNotNil ]) size should
		equal: 2.
	node children first should equal: leaf1.
	node children second should equal: leaf2.

	node prefix should equal: ByteArray new.
	node prefixSize should equal: 0.

	(node keys at: 1) should equal: leaf1 key first.
	(node children at: 1) should equal: leaf1.

	(node keys at: 2) should equal: leaf2 key first.
	(node children at: 2) should equal: leaf2
]
