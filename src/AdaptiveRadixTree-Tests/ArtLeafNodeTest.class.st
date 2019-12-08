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
ArtLeafNodeTest >> testMatchesKey [
	| node |

	node := ArtLeafNode new
		key: 'hello' asByteArray ensureNullTerminated;
		value: 'world';
		yourself.
	(node matchesKey: 'hello') should be: true.
	(node matchesKey: ' hello') should be: false.
	(node matchesKey: 'h') should be: false.
	(node matchesKey: '') should be: false
]

{ #category : #tests }
ArtLeafNodeTest >> testPutAtEnd [
	| node leaf2 leaf1 tree |

	tree := ArtTree new.
	node := (ArtLeafNode on: tree)
		key: 'abc' asByteArray ensureNullTerminated;
		value: 'ABC';
		parent: tree;
		yourself.
	leaf1 := node copy.
	leaf2 := (ArtLeafNode on: tree)
		key: 'abcd' asByteArray ensureNullTerminated;
		value: 'abcd';
		yourself.

	tree initializeWithRoot: node.
	node at: leaf2 key put: leaf2 value depth: 1.
	node := tree root.
	node should beKindOf: ArtNode4.
	node size should equal: 2.

	(node children select: [ :each | each isNotNil ]) size should
		equal: 2.
	node children first should equal: leaf1.
	node children second should equal: leaf2.

	(node prefix copyFrom: 1 to: node prefixSize) should equal: 'abc' asByteArray.
	node prefixSize should equal: 3.

	(node keys at: 1) should equal: leaf1 key fourth.
	(node children at: 1) should equal: leaf1.

	(node keys at: 2) should equal: leaf2 key fourth.
	(node children at: 2) should equal: leaf2
]

{ #category : #tests }
ArtLeafNodeTest >> testPutAtMiddle [
	| node leaf2 leaf1 tree |

	tree := ArtTree new.
	node := (ArtLeafNode on: tree)
		key: 'abc' asByteArray ensureNullTerminated;
		value: 'ABC';
		parent: tree;
		yourself.
	leaf1 := node copy.
	leaf2 := (ArtLeafNode on: tree)
		key: 'abd' asByteArray ensureNullTerminated;
		value: 'ABD';
		yourself.

	tree initializeWithRoot: node.
	node at: leaf2 key put: leaf2 value depth: 1.
	node := tree root.
	node should beKindOf: ArtNode4.
	node size should equal: 2.

	(node children select: [ :each | each isNotNil ]) size should
		equal: 2.
	node children first should equal: leaf1.
	node children second should equal: leaf2.

	(node prefix copyFrom: 1 to: node prefixSize) should equal: 'ab' asByteArray.
	node prefixSize should equal: 2.

	(node keys at: 1) should equal: leaf1 key third.
	(node children at: 1) should equal: leaf1.

	(node keys at: 2) should equal: leaf2 key third.
	(node children at: 2) should equal: leaf2
]

{ #category : #tests }
ArtLeafNodeTest >> testPutAtStart [
	| node leaf2 leaf1 tree |

	tree := ArtTree new.
	node := (ArtLeafNode on: tree)
		key: 'abc' asByteArray ensureNullTerminated;
		value: 'ABC';
		parent: tree;
		yourself.
	leaf1 := node copy.
	leaf2 := (ArtLeafNode on: tree)
		key: 'def' asByteArray ensureNullTerminated;
		value: 'DEF';
		yourself.

	tree initializeWithRoot: node.
	node at: leaf2 key put: leaf2 value depth: 1.
	node := tree root.
	node should beKindOf: ArtNode4.
	node size should equal: 2.

	(node children select: [ :each | each isNotNil ]) size should
		equal: 2.
	node children first should equal: leaf1.
	node children second should equal: leaf2.

	(node prefix copyFrom: 1 to: node prefixSize) should equal: ByteArray new.
	node prefixSize should equal: 0.

	(node keys at: 1) should equal: leaf1 key first.
	(node children at: 1) should equal: leaf1.

	(node keys at: 2) should equal: leaf2 key first.
	(node children at: 2) should equal: leaf2
]
