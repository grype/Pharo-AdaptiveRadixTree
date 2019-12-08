Class {
	#name : #ArtLeafNode,
	#superclass : #ArtNode,
	#instVars : [
		'key',
		'value'
	],
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #comparing }
ArtLeafNode >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ value = anObject value and: [ key = anObject key ]
]

{ #category : #accessing }
ArtLeafNode >> at: aKey depth: depth [
	^ (self matchesKey: aKey)
		ifTrue: [ value ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
ArtLeafNode >> at: aKey put: aValue depth: depth [
	"Insert aValue at aKey, starting with given depth. This method is meant to be called recursively and is expected to return the inserted value"

	| newLeaf newContainer lcp newContainerPrefix |

	(self matchesKey: aKey)
		ifTrue: [ self value: aValue.
			^ false ].

	newContainer := ArtNode4 on: tree.
	newLeaf := (ArtLeafNode on: tree)
		key: aKey;
		value: aValue;
		yourself.
	lcp := key longestCommonPrefixWith: aKey startingAt: depth.
	newContainerPrefix := newContainer prefix.
	1 to: (lcp min: ArtContainerNode maxPrefixSize) do: [ :i | newContainerPrefix at: i put: (aKey at: depth - 1 + i) ].
	newContainer prefixSize: lcp.

	parent replaceChild: self with: newContainer.
	newContainer addChild: self at: (self key at: depth + lcp).
	newContainer addChild: newLeaf at: (aKey at: depth + lcp).
	tree addedChildren: 1.
	^ aValue
]

{ #category : #enumerating }
ArtLeafNode >> do: aBlock [
	aBlock cull: self
]

{ #category : #comparing }
ArtLeafNode >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ value hash bitXor: key hash
]

{ #category : #testing }
ArtLeafNode >> isLeaf [
	^ true
]

{ #category : #accessing }
ArtLeafNode >> key [
	^ key
]

{ #category : #accessing }
ArtLeafNode >> key: anObject [
	key := anObject
]

{ #category : #private }
ArtLeafNode >> leafNodes [
	^ {self}
]

{ #category : #testing }
ArtLeafNode >> matchesKey: aKey [
	aKey ifEmpty: [ ^ false ].
	^ aKey isNotNil and: [ aKey asByteArray ensureNullTerminated = key ]
]

{ #category : #accessing }
ArtLeafNode >> maximum [
	^ self
]

{ #category : #accessing }
ArtLeafNode >> minimum [
	"Returns the left-most leaf node by recursively traversing children using lowest byte index"
	^ self
]

{ #category : #accessing }
ArtLeafNode >> nodeAt: aKey depth: depth [
	^ (self matchesKey: aKey)
		ifTrue: [ self ]
		ifFalse: [ nil ]
]

{ #category : #printing }
ArtLeafNode >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' key: ';
		print: key
]

{ #category : #removing }
ArtLeafNode >> removeKey: aKey ifAbsent: absentBlock depth: depth [
	^ self shouldNotImplement 
]

{ #category : #accessing }
ArtLeafNode >> size [
	^ 0
]

{ #category : #accessing }
ArtLeafNode >> totalSizeInMemory [
	^ self sizeInMemory + key sizeInMemory + value sizeInMemory
]

{ #category : #accessing }
ArtLeafNode >> value [
	^ value
]

{ #category : #accessing }
ArtLeafNode >> value: anObject [
	value := anObject
]
