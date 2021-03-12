"
Presenter for a folder structure
"
Class {
	#name : #StSimpleFolderStructurePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tree'
	],
	#category : #'NewTools-SimpleFileBrowser-UI-Components'
}

{ #category : #specs }
StSimpleFolderStructurePresenter class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		add: #tree;
		yourself
]

{ #category : #specs }
StSimpleFolderStructurePresenter class >> open [ 
	<script>
	self new openWithSpec 
]

{ #category : #actions }
StSimpleFolderStructurePresenter >> browseFolder [
	 tree selectedItem browseFolder 
]

{ #category : #'menu handling' }
StSimpleFolderStructurePresenter >> folderContextMenu [

	^(SpMenuPresenter new
		addGroup: [ :group | group
			addItem: [ :item | item name: 'Open in native browser';  action: [ self browseFolder ]]
		])
]

{ #category : #initialization }
StSimpleFolderStructurePresenter >> initializeWidgets [
	tree := self newTreeTable.
	tree
		addColumn:
			(SpCompositeTableColumn new
				title: self title;
				addColumn:
					(SpImageTableColumn new
						width: 20;
						evaluated: #icon;
						yourself);
				addColumn:
					(SpStringTableColumn new
						evaluated: #label;
						yourself);
				yourself);
	 
		roots: StSimpleFileSystemItemWrapper roots;
		children: [ :aClass | aClass subdirectories ];
		beResizable.
	tree contextMenu: self folderContextMenu		
]

{ #category : #initialization }
StSimpleFolderStructurePresenter >> title [
	^Smalltalk os isWindows 
		ifTrue: ' Drives and Folders' 
  		ifFalse: ' Folders' 
	
]

{ #category : #'api-events' }
StSimpleFolderStructurePresenter >> whenFolderChangedDo: aBlock [
	
	tree whenSelectionChangedDo: [:sel | aBlock cull: sel selectedItem ]
]
