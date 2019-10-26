Class {
	#name : #ArtTree,
	#superclass : #Object,
	#instVars : [
		'root',
		'size'
	],
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #'state tracking' }
ArtTree >> addedChildren: aCount [
	size := size + aCount
]

{ #category : #searching }
ArtTree >> at: aKey [
	^ root
		ifNotNil: [ :node | node at: aKey asByteArray ensureNullTerminated depth: 1 ]
]

{ #category : #accessing }
ArtTree >> at: aKey put: aValue [
	"Puts given value at given key. If a leaf node matching the key exists - its value is updated, otherwise - a new leaf node is created, manipulating intemediate node structure if needed. Returns inserted value"

	| key |

	key := aKey asByteArray ensureNullTerminated.
	^ ArtCurrentTree
		value: self
		during: [ root
				ifNil: [ root := ArtNode leafWithKey: key value: aValue.
					size := size + 1.
					aValue ]
				ifNotNil: [ root at: key put: aValue depth: 1 ] ]
]

{ #category : #accessing }
ArtTree >> errorKeyNotFound: aKey [

	KeyNotFound signalFor: aKey
]

{ #category : #initialization }
ArtTree >> initialize [
	super initialize.
	size := 0
]

{ #category : #accessing }
ArtTree >> removeKey: aKey [
	^ self removeKey: aKey ifAbsent: [ self errorKeyNotFound: aKey ]
]

{ #category : #removing }
ArtTree >> removeKey: aKey ifAbsent: absentBlock [
	"Remove and answer value associated with given key. If key is not found, answer result of evaluating absentBlock."

	| k |

	k := aKey asByteArray ensureNullTerminated.
	^ ArtCurrentTree
		value: self
		during: [ root
				ifNil: [ absentBlock value ]
				ifNotNil: [ root isLeaf
						ifTrue: [ | val |

							val := root.
							root := nil.
							self removedChildren: 1.
							val ]
						ifFalse: [ root removeKey: k ifAbsent: absentBlock depth: 1 ] ] ]
]

{ #category : #'state tracking' }
ArtTree >> removedChildren: aCount [
	size := size - aCount
]

{ #category : #accessing }
ArtTree >> root [
	^ root
]

{ #category : #accessing }
ArtTree >> size [
	^ size
]
