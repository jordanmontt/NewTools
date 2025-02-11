Class {
	#name : 'StKMCategory',
	#superclass : 'Object',
	#instVars : [
		'categoryName',
		'keymaps'
	],
	#category : 'NewTools-ShortcutsBrowser',
	#package : 'NewTools-ShortcutsBrowser'
}

{ #category : 'copying' }
StKMCategory >> , aKMCategory [

	keymaps addAll: aKMCategory allEntries keymaps
]

{ #category : 'comparing' }
StKMCategory >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ categoryName = anObject categoryName and: [
		  keymaps = anObject keymaps ]
]

{ #category : 'adding' }
StKMCategory >> addAllShortcuts: aCollection [ 
	"Add all keymaps in aCollection to the receiver"
	
	self keymaps addAll: aCollection
]

{ #category : 'accessing' }
StKMCategory >> categoryName [

	^ categoryName
]

{ #category : 'accessing' }
StKMCategory >> categoryName: anObject [

	categoryName := anObject
]

{ #category : 'comparing' }
StKMCategory >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ categoryName hash bitXor: keymaps hash
]

{ #category : 'accessing' }
StKMCategory >> icon [

	^ self iconNamed: self systemIconName
]

{ #category : 'initialization' }
StKMCategory >> initialize [

	super initialize.
	keymaps := OrderedCollection new
]

{ #category : 'accessing' }
StKMCategory >> keymaps [

	^ keymaps
]

{ #category : 'accessing' }
StKMCategory >> keymaps: anObject [

	keymaps := anObject
]

{ #category : 'accessing' }
StKMCategory >> model [
	"Required by <SpDropListPresenter> ?"

	^ self
]

{ #category : 'accessing' }
StKMCategory >> name [

	^  self categoryName
]

{ #category : 'printing' }
StKMCategory >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: ' [';
		print: categoryName;
		nextPutAll: ']'
]
