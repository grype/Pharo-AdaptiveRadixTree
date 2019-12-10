Class {
	#name : #ArtTreeTest,
	#superclass : #TestCase,
	#instVars : [
		'tree'
	],
	#classVars : [
		'Charset'
	],
	#category : #'AdaptiveRadixTree-Tests-Core'
}

{ #category : #'initialize - event' }
ArtTreeTest class >> initialize [
	Charset := ByteArray new: 256.
	1 to: 255 do: [ :i | Charset at: i put: i ]
]

{ #category : #running }
ArtTreeTest >> setUp [
	super setUp.
	tree := ArtTree new
]

{ #category : #tests }
ArtTreeTest >> stringFrom: start to: end [
	^ (Charset copyFrom: start to: end) asString
]

{ #category : #tests }
ArtTreeTest >> testGrowFrom16to48 [
	| data offset root prefix |

	offset := 96.
	prefix := 'pfx-'.

	data := (1 to: 17)
		collect: [ :i | prefix , (self stringFrom: offset + i to: offset + i + 4) ].

	data do: [ :each | tree at: each put: each ].

	root := tree root.
	root should beKindOf: ArtNode48.
	data do: [ :each | (tree at: each) should equal: each ].

	root prefixSize should equal: prefix size.
	(root prefix first: prefix size) should equal: prefix asByteArray.

	(root children select: #isNotNil) size should equal: data size.

	(root children first: 17)
		withIndexDo: [ :child :index | 
			| byte |

			child should beKindOf: ArtLeafNode.
			child key should
				equal: (data at: index) asByteArray ensureNullTerminated.
			child value should equal: (data at: index).
			child parent should be: root.
			byte := child key at: prefix size + 1.
			(root keys at: byte + 1) should equal: index ]
]

{ #category : #tests }
ArtTreeTest >> testGrowFrom4to16 [
	| data offset root prefix |

	offset := 96.
	prefix := 'pfx-'.

	data := (1 to: 5)
		collect: [ :i | prefix , (self stringFrom: offset + i to: offset + i + 4) ].

	data do: [ :each | tree at: each put: each ].

	root := tree root.
	root should beKindOf: ArtNode16.
	data do: [ :each | (tree at: each) should equal: each ].

	root prefixSize should equal: prefix size.
	(root prefix first: prefix size) should equal: prefix asByteArray.

	(root keys first: 5) should
		equal:
			(data
				collect: [ :each | (each at: prefix size + 1) asInteger ]
				as: ByteArray).
				
	(root children first: 5)
		withIndexDo: [ :child :index | 
			child should beKindOf: ArtLeafNode.
			child key should
				equal: (data at: index) asByteArray ensureNullTerminated.
			child value should equal: (data at: index).
			child parent should be: root ]
]

{ #category : #tests }
ArtTreeTest >> testInsert1 [
	tree at: 'hello' put: 'world'.
	tree size should equal: 1.
	tree root should beKindOf: ArtLeafNode.
	tree root key should equal: 'hello' asByteArray ensureNullTerminated.
	tree root value should equal: 'world'.
	(tree at: 'hello') should equal: 'world'.
]

{ #category : #tests }
ArtTreeTest >> testInsert2Identical [
	tree at: 'abc' put: 'ABC'.
	tree at: 'abc' put: 'ABC'.
	tree size should equal: 1.

	tree root should beKindOf: ArtLeafNode
]

{ #category : #tests }
ArtTreeTest >> testInsert2Similar [
	| root firstChild secondChild |

	tree at: 'abc' put: 'ABC'.
	tree at: 'abd' put: 'ABD'.
	tree size should equal: 2.

	root := tree root.
	root should beKindOf: ArtNode4.
	root size should equal: 2.
	(root prefix copyFrom: 1 to: 2) should equal: 'ab' asByteArray.

	firstChild := root children first.
	firstChild should beKindOf: ArtLeafNode.
	firstChild key should equal: 'abc' asByteArray ensureNullTerminated.
	firstChild value should equal: 'ABC'.
	
	secondChild := root children second.
	secondChild should beKindOf: ArtLeafNode.
	secondChild key should equal: 'abd' asByteArray ensureNullTerminated.
	secondChild value should equal: 'ABD'
]

{ #category : #tests }
ArtTreeTest >> testInsert3Dissimilar [
	| root firstChild secondChild thirdChild |

	tree at: 'alice' put: 'Alice'.
	tree at: 'bob' put: 'Bob'.
	tree at: 'carl' put: 'Carl'.
	tree size should equal: 3.

	root := tree root.
	root should beKindOf: ArtNode4.
	root size should equal: 3.
	root prefix asSet should equal: (Set with: 0).

	firstChild := root children first.
	firstChild should beKindOf: ArtLeafNode.
	firstChild key should equal: 'alice' asByteArray ensureNullTerminated.
	firstChild value should equal: 'Alice'.

	secondChild := root children second.
	secondChild should beKindOf: ArtLeafNode.
	secondChild key should equal: 'bob' asByteArray ensureNullTerminated.
	secondChild value should equal: 'Bob'.

	thirdChild := root children third.
	thirdChild should beKindOf: ArtLeafNode.
	thirdChild key should equal: 'carl' asByteArray ensureNullTerminated.
	thirdChild value should equal: 'Carl'
]

{ #category : #tests }
ArtTreeTest >> testInsert3Dissimilar2 [
	| root firstChild secondChild thirdChild |

	tree at: 'Charadrii' put: 'Charadrii'.
	tree at: 'tamable' put: 'tamable'.
	tree at: 'lengthy' put: 'lengthy'.
	tree size should equal: 3.

	root := tree root.
	root should beKindOf: ArtNode4.
	root size should equal: 3.
	root prefix asSet should equal: (Set with: 0).

	firstChild := root children first.
	firstChild should beKindOf: ArtLeafNode.
	firstChild key should equal: 'Charadrii' asByteArray ensureNullTerminated.
	firstChild value should equal: 'Charadrii'.

	secondChild := root children second.
	secondChild should beKindOf: ArtLeafNode.
	secondChild key should equal: 'lengthy' asByteArray ensureNullTerminated.
	secondChild value should equal: 'lengthy'.

	thirdChild := root children third.
	thirdChild should beKindOf: ArtLeafNode.
	thirdChild key should equal: 'tamable' asByteArray ensureNullTerminated.
	thirdChild value should equal: 'tamable'
]

{ #category : #tests }
ArtTreeTest >> testInsertFrom: start to: end expectedType: aType [
	start to: end do: [ :i | 
		| s |

		s := self stringFrom: i to: i + 1.
		tree at: s put: s.
		(tree at: s) should equal: s ].
	tree size should equal: end - start + 1.

	tree root size should equal: end - start + 1.
	tree root should beKindOf: aType.

	start to: end do: [ :i | 
		| s |

		s := self stringFrom: i to: i + 1.
		(tree at: s) should equal: s ]
]

{ #category : #tests }
ArtTreeTest >> testInsertMany [
	self testInsertFrom: 1 to: 2 expectedType: ArtNode4.
	self testInsertFrom: 1 to: 4 expectedType: ArtNode4.
	self testInsertFrom: 1 to: 5 expectedType: ArtNode16.
	self testInsertFrom: 1 to: 16 expectedType: ArtNode16.
	self testInsertFrom: 1 to: 17 expectedType: ArtNode48.
	self testInsertFrom: 1 to: 48 expectedType: ArtNode48.
	self testInsertFrom: 1 to: 49 expectedType: ArtNode256.
	self testInsertFrom: 1 to: 255 expectedType: ArtNode256
]

{ #category : #tests }
ArtTreeTest >> testInsertRemove1 [
	tree at: 'abc' put: 'ABC'.
	tree removeKey: 'abc'.
	tree size should equal: 0.
	tree root should be: nil.
]

{ #category : #tests }
ArtTreeTest >> testInsertTwice [
	| root firstChild secondChild thirdChild |

	tree at: 'Charadrii' put: 'Charadrii'.
	tree at: 'tamable' put: 'tamable'.
	tree at: 'lengthy' put: 'lengthy'.
	tree at: 'Charadrii' put: 'Charadrii'.
	tree at: 'tamable' put: 'tamable'.
	tree at: 'lengthy' put: 'lengthy'.
	tree size should equal: 3.

	root := tree root.
	root should beKindOf: ArtNode4.
	root size should equal: 3.
	root prefix asSet should equal: (Set with: 0).

	firstChild := root children first.
	firstChild should beKindOf: ArtLeafNode.
	firstChild key should equal: 'Charadrii' asByteArray ensureNullTerminated.
	firstChild value should equal: 'Charadrii'.

	secondChild := root children second.
	secondChild should beKindOf: ArtLeafNode.
	secondChild key should equal: 'lengthy' asByteArray ensureNullTerminated.
	secondChild value should equal: 'lengthy'.

	thirdChild := root children third.
	thirdChild should beKindOf: ArtLeafNode.
	thirdChild key should equal: 'tamable' asByteArray ensureNullTerminated.
	thirdChild value should equal: 'tamable'
]
