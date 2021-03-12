"
My responsibility is to provide dialog for SAVING files.
"
Class {
	#name : #FDSaveFileDialogPresenter,
	#superclass : #FDFileDialogPresenter,
	#instVars : [
		'extensionMather'
	],
	#classVars : [
		'Matcher'
	],
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #examples }
FDSaveFileDialogPresenter class >> example [ 	
	<example>
		^ self new openDialogWithSpec
]

{ #category : #examples }
FDSaveFileDialogPresenter class >> exampleExtension [
	<example>
	^ self extension: '*.jpg'
]

{ #category : #accessing }
FDSaveFileDialogPresenter class >> extension: aExtensionMatcher [
	"example 
		you want to save png File 
			FDSaveFileDialog extension: 'jpg'
	"

	^ self new
		extension: aExtensionMatcher;
		openDialogWithSpec;
		yourself
]

{ #category : #'class initialization' }
FDSaveFileDialogPresenter class >> initialize [ 
	Matcher := '*'
]

{ #category : #initialization }
FDSaveFileDialogPresenter >> connectPresenters [
	| ec |
	super connectPresenters.
	(ec := EntryCompletion new)
		dataSourceBlock: [ :text | fileNavigationSystem currentDirectory children collect: #basename ];
		filterBlock: [ :opt :text |opt beginsWith: text ].
	fileNavigationSystem nameText entryCompletion: ec
]

{ #category : #'api-customization' }
FDSaveFileDialogPresenter >> extension: anExtensionMatcher [
	extensionMather := anExtensionMatcher
]

{ #category : #api }
FDSaveFileDialogPresenter >> initialTitle [
	^ 'Save As'
]

{ #category : #initialization }
FDSaveFileDialogPresenter >> initialize [
	super initialize.
	extensionMather := Matcher
]

{ #category : #accessing }
FDSaveFileDialogPresenter >> selectedEntry [
	| entry proceed |
	entry := fileNavigationSystem currentDirectory /fileNavigationSystem nameText text.
	(fileNavigationSystem nameText text includes: extensionMather)
		ifFalse: [ entry := entry
				, ((extensionMather copyReplaceAll: '*' with: '') ) ].
	proceed := false.
	entry exists
		ifTrue: [ proceed := UIManager default
				proceed:
					('File named "{1}" already exists. Do you want to overwrite it?'
						format: {entry printString}) ].
	^ proceed
		ifTrue: [ entry ]
		ifFalse: [ nil ]
]
