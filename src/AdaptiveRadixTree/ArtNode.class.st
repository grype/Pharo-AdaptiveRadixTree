Class {
	#name : #ArtNode,
	#superclass : #Object,
	#instVars : [
		'tree',
		'parent'
	],
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #'instance creation' }
ArtNode class >> on: aTree [
	^ self new
		tree: aTree;
		yourself
]

{ #category : #accessing }
ArtNode >> at: aKey depth: anObject [
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtNode >> at: aKey put: aValue depth: depth [
	"Insert aValue at aKey, starting with given depth. This method is meant to be called recursively.
	 Returns true if a node was actually added (as opposed to updating existing node)."
	^ self subclassResponsibility 
]

{ #category : #testing }
ArtNode >> isLeaf [
	^ false
]

{ #category : #private }
ArtNode >> leafNodes [
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtNode >> maximum [
	"Returns the right-most leaf node by recursively traversing children using highest byte index"
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtNode >> minimum [
	"Returns the left-most leaf node by recursively traversing children using lowest byte index"
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtNode >> nodeAt: aKey depth: anObject [
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtNode >> parent [
	^ parent
]

{ #category : #accessing }
ArtNode >> parent: anObject [
	parent := anObject
]

{ #category : #removing }
ArtNode >> removeKey: aKey ifAbsent: absentBlock depth: depth [
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtNode >> size [
	"Returns number of children"
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtNode >> totalSizeInMemory [
	^ self subclassResponsibility
]

{ #category : #accessing }
ArtNode >> tree [
	^ tree
]

{ #category : #accessing }
ArtNode >> tree: anObject [
	tree := anObject
]
