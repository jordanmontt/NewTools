"
My responsibility is to provide dialog for selecting Files.

see my super for more information about customization

examples see class side method example

"
Class {
	#name : #FDOpenFileDialogPresenter,
	#superclass : #FDFileDialogPresenter,
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #api }
FDOpenFileDialogPresenter >> initialTitle [
	^ 'Select File To Open'
]

{ #category : #initialization }
FDOpenFileDialogPresenter >> initializePresenters [
	super initializePresenters.
	fileNavigationSystem nameText disable
]

{ #category : #accessing }
FDOpenFileDialogPresenter >> selectedEntry [
	^ fileNavigationSystem selectedEntry
]
