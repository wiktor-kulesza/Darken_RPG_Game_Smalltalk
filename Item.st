Object subclass: Item [
    | isOpenable whatOpens isOpened name items canTake|

    getCanTake [^canTake.]

    newCanTake: newCanTake [canTake := newCanTake.]    

    getIsOpenable [^isOpenable.]

    newIsOpenable: newIsOpenable [isOpenable := newIsOpenable.] 

    getIsOpened [^isOpened.]

    newIsOpened: newIsOpened [isOpened := newIsOpened.] 
    
    getName [^name.]

    newName: newName [name := newName.]

    getWhatOpens [^whatOpens.]

    newWhatOpens: newWhatOpens [whatOpens := newWhatOpens.]

    getItems [^items.]

    newItems: newItems [items := newItems.]

    getItemInsideItem: item [
        self getItems do: [ 
            :a| (a getName = item) & (a getCanTake) ifTrue: [
                ^a
            ]
        ].
        ^nil.
    ]

    checkIfItemInsideItem: itemName [
        self getItems do: [ 
            :a| (a getName = itemName) & (a getCanTake) ifTrue: [
                ^true
            ]
        ].
        ^false.        
    ]


    Item class >> new [
        | r |
        <category: 'instance creation'>
        r := super new.
        r init.
        ^r.

    ]

    init [
        self newCanTake: true.
        self newWhatOpens: OrderedCollection new.
    ]
]