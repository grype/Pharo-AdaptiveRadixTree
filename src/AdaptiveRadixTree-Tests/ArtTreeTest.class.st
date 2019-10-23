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
ArtTreeTest >> testInsert1 [
	tree at: 'hello' put: 'world'.
	tree size should equal: 1.
	tree root should beKindOf: ArtLeafNode.
	tree root key should equal: 'hello' asByteArray ensureNullTerminated.
	tree root value should equal: 'world'.
	(tree search: 'hello') should equal: 'world'.
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
	tree at: 'abc' put: 'ABC'.
	tree at: 'abd' put: 'ABD'.
	tree size should equal: 2.

	tree root should beKindOf: ArtNode4.
	tree root 
]

{ #category : #tests }
ArtTreeTest >> testInsertFrom: start to: end expectedType: aType [
	start to: end do: [ :i | 
		| s |

		s := self stringFrom: i to: i + 1.
		tree at: s put: s.
		(tree search: s) should equal: s ].
	tree size should equal: end - start + 1.

	tree root size should equal: end - start + 1.
	tree root should beKindOf: aType.

	start to: end do: [ :i | 
		| s |

		s := self stringFrom: i to: i + 1.
		(tree search: s) should equal: s ]
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
