"
I am a node of an Adaptive Radix Tree.

I represent an abstract implementation of two kinds of nodes - a leaf or a container. Leaf nodes hold key-value associations, while container nodes store a collection of child nodes. See class comments of my subclasses for details...

Access values (which could be a child node) using:

- #at:depth:
- #at:put:depth

Access nodes: 

- #nodeAt:depth:

Enumeration: 

- #associationsDo: enumerates over leaf nodes, using their key-value associations
- #childreWithkeys returns a list of a dictionary of child children by key

Instance Variables
	parent:		<ArtNode> | <ArtTree>
	tree:		<ArtTree>
			
To aid in enumeration and tallying, I keep references to parent entity, which could be the tree or another node, and to the owning tree.
"
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
ArtNode >> allNodes [
	| collection |

	collection := OrderedCollection new.
	self withAllChildNodesDo: [ :node | collection add: node ].
	^ collection 
]

{ #category : #enumerating }
ArtNode >> associationsDo: aBlock [
	^ self subclassResponsibility 
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
ArtNode >> tree [
	^ tree
]

{ #category : #accessing }
ArtNode >> tree: anObject [
	tree := anObject
]

{ #category : #enumerating }
ArtNode >> valuesDo: aBlock [
	^ self subclassResponsibility 
]

{ #category : #enumerating }
ArtNode >> withAllChildNodesDo: aBlock [
	aBlock cull: self.
	self childrenWithKeys do: [ :assoc | assoc value withAllChildNodesDo: aBlock ]
]
