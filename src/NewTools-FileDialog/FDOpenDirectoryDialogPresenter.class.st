"
My responsibility is to provide dialog for selecting Directories.

So no files will be shown in the file/folder listings.

see my super for more information about customization
"
Class {
	#name : #FDOpenDirectoryDialogPresenter,
	#superclass : #FDFileDialogPresenter,
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #examples }
FDOpenDirectoryDialogPresenter class >> example [
	<example>
	^ (self new
		okAction: [ :selectedFileReference | selectedFileReference inspect ])
		openDialogWithSpec inspect
]

{ #category : #api }
FDOpenDirectoryDialogPresenter >> initialTitle [
	^ 'Select Directory To Open'
]

{ #category : #initialization }
FDOpenDirectoryDialogPresenter >> initializePresenters [
	super initializePresenters.
	fileNavigationSystem nameText disable
]

{ #category : #actions }
FDOpenDirectoryDialogPresenter >> nameChanged [
	"we don't need to do anything for folder"

	
]

{ #category : #actions }
FDOpenDirectoryDialogPresenter >> selectedEntry [
	fileNavigationSystem selectedEntry ifNotNil: [ :fileReference | fileReference isDirectory ifTrue: [ ^ fileReference ] ].
	self inform: 'you must select a directory'
]
