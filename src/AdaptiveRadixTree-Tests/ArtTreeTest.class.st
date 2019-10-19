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
	1 to: 256 do: [ :i | Charset at: i put: i - 1 ]
]

{ #category : #running }
ArtTreeTest >> setUp [
	super setUp.
	tree := ArtTree new
]

{ #category : #tests }
ArtTreeTest >> stringFrom: start to: end [
	^ Charset copyFrom: start to: end
]

{ #category : #tests }
ArtTreeTest >> testInsert1 [
	tree at: 'hello' put: 'world'.
	tree size should equal: 1.
	tree root should beKindOf: ArtLeafNode.
	tree root key should equal: 'hello' asByteArray ensureNullTerminated.
	tree root value should equal: 'world'
]

{ #category : #tests }
ArtTreeTest >> testInsert16 [
	1 to: 16 do: [ :i |
		| s |
		s := self stringFrom: i to: i + 1.
		tree at: s put: s.
		].
	tree size should equal: 16.
	
	tree root should beKindOf: ArtNode16.
	tree root size should equal: 16
]

{ #category : #tests }
ArtTreeTest >> testInsert17 [
	1 to: 17 do: [ :i |
		| s |
		s := self stringFrom: i to: i + 1.
		tree at: s put: s.
		].
	tree size should equal: 17.
	
	tree root should beKindOf: ArtNode48.
	tree root size should equal: 17
]

{ #category : #tests }
ArtTreeTest >> testInsert2 [
	1 to: 2 do: [ :i |
		| s |
		s := self stringFrom: i to: i + 1.
		tree at: s put: s.
		].
	tree size should equal: 2.
	
	tree root should beKindOf: ArtNode4.
	tree root size should equal: 2
]

{ #category : #tests }
ArtTreeTest >> testInsert255 [
	1 to: 255 do: [ :i | 
		| s |

		s := self stringFrom: i to: i + 1.
		tree at: s put: s ].
	tree size should equal: 255.

	tree root should beKindOf: ArtNode256.
	tree root size should equal: 255
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
ArtTreeTest >> testInsert3 [
	1 to: 3 do: [ :i | 
		| s |

		s := self stringFrom: i to: i + 1.
		tree at: s put: s ].
	tree size should equal: 3.

	tree root should beKindOf: ArtNode4.
	tree root size should equal: 3
]

{ #category : #tests }
ArtTreeTest >> testInsert4 [
	1 to: 4 do: [ :i | 
		| s |

		s := self stringFrom: i to: i + 1.
		tree at: s put: s ].
	tree size should equal: 4.

	tree root should beKindOf: ArtNode4.
	tree root size should equal: 4
]

{ #category : #tests }
ArtTreeTest >> testInsert48 [
	1 to: 49 do: [ :i | 
		| s |

		s := self stringFrom: i to: i + 1.
		tree at: s put: s ].
	tree size should equal: 49.

	tree root should beKindOf: ArtNode256.
	tree root size should equal: 49
]

{ #category : #tests }
ArtTreeTest >> testInsert5 [
	1 to: 5 do: [ :i | 
		| s |

		s := self stringFrom: i to: i + 1.
		tree at: s put: s ].
	tree size should equal: 5.

	tree root should beKindOf: ArtNode16.
	tree root size should equal: 5
]
