#
# M2: Intrinsic modules with relations and generators for the CAP based homalg
#
# Implementations

##
InstallMethod( TurnAutoequivalenceIntoIdentityFunctorForHomalg,
        "for a CAP natural isomorphism and a CAP category",
        [ IsCapNaturalTransformation, IsCapCategory ],

  function( natiso, cat_intrinsic )
    local F, cat_with_amb_objects, Id;
    
    F := Range( natiso );
    
    ## CategoryWithAmbientObject
    
    if not HasIntrinsifiedCategory( cat_intrinsic ) then
        Error( "the second argument is not an intrinsic category\n" );
    fi;
    
    cat_with_amb_objects := IntrinsifiedCategory( cat_intrinsic );
    
    Id := IdentityFunctor( cat_with_amb_objects );
    
    F := WithAmbientObject( F, cat_with_amb_objects );
    
    natiso := WithAmbientObject( natiso, Id, F );
    
    ## IntrinsicCategory
    
    Id := IdentityFunctor( cat_intrinsic );
    
    F := Intrinsify( F, cat_intrinsic );
    
    natiso := Intrinsify( natiso, Id, F );
    
    ## TurnAutoequivalenceIntoIdentityFunctor
    
    return TurnAutoequivalenceIntoIdentityFunctor( natiso );
    
end );

##
InstallGlobalFunction( INSTALL_TODO_LISTS_FOR_HOMALG_MORPHISMS,
  function( input, output )
    local conds;
    
    input := Flat( input );
    
    input := Filtered( input, IsCapCategoryMorphism );
    
    if input = [ ] then
        SetIsMorphism( output, true );
    fi;
    
    conds := List( input, a -> [ a, "IsMorphism", true ] );
    
    AddToToDoList( ToDoListEntry( conds,
            [ [ "if IsMorphism = true for all morphisms in input then SetIsMorphism( output, true )",
                [ output, "IsMorphism", true ],
                ],
             ]
            ) );
    
    AddToToDoList( ToDoListEntry( [ [ output, "CokernelProjection" ] ],
            [ [ "in the category of finite presentations the CokernelProjection( phi ) is always well-defined regardless of the consistency of phi",
                function( )
                  SetIsMorphism( CokernelProjection( output ), true );
                end
                  ] ]
                  ) );
    
end );

##
InstallMethod( CategoryOfHomalgLeftModules,
        "for a homalg ring",
        [ IsHomalgRing ],

  function( R )
    local A, type_obj, type_mor, type_end, etaSM, etaZG, etaLG;
    
    A := LeftPresentations( R : FinalizeCategory := false );
    
    AddImageEmbedding( A, ImageEmbeddingForLeftModules );
    
    Finalize( A );
    
    A := CategoryWithAmbientObject( A );
    
    type_obj :=
      NewType( TheFamilyOfIntrinsicObjects,
              IsCapCategoryIntrinsicObjectRep and
              IsFinitelyPresentedModuleRep and
              IsHomalgLeftObjectOrMorphismOfLeftObjects
              );
    
    type_mor :=
      NewType( TheFamilyOfIntrinsicMorphisms,
              IsCapCategoryIntrinsicMorphismRep and
              IsMapOfFinitelyGeneratedModulesRep and
              IsHomalgLeftObjectOrMorphismOfLeftObjects
              );
    
    type_end :=
      NewType( TheFamilyOfIntrinsicMorphisms,
              IsCapCategoryIntrinsicMorphismRep and
              IsHomalgSelfMap and
              IsMapOfFinitelyGeneratedModulesRep and
              IsHomalgLeftObjectOrMorphismOfLeftObjects
              );
    
    A := IntrinsicCategory( A, type_obj, type_mor, type_end, INSTALL_TODO_LISTS_FOR_HOMALG_MORPHISMS );
    
    ## TODO: legacy
    SetFilterObj( A, IsHomalgCategory );
    A!.containers := rec( );
    
    etaSM := NaturalIsomorphismFromIdentityToStandardModuleLeft( R );
    
    A!.IdSM := TurnAutoequivalenceIntoIdentityFunctorForHomalg( etaSM, A );
    
    etaZG := NaturalIsomorphismFromIdentityToGetRidOfZeroGeneratorsLeft( R );
    
    A!.IdZG := TurnAutoequivalenceIntoIdentityFunctorForHomalg( etaZG, A );

    etaLG := NaturalIsomorphismFromIdentityToLessGeneratorsLeft( R );
    
    A!.IdLG := TurnAutoequivalenceIntoIdentityFunctorForHomalg( etaLG, A );
    
    return A;
    
end );

##
InstallMethod( CategoryOfHomalgRightModules,
        "for homalg ring",
        [ IsHomalgRing ],

  function( R )
    local A, type_obj, type_mor, type_end, etaSM, etaZG, etaLG;
    
    A := RightPresentations( R : FinalizeCategory := false );
    
    AddImageEmbedding( A, ImageEmbeddingForRightModules );
    
    Finalize( A );
    
    A := CategoryWithAmbientObject( A );
    
    type_obj :=
      NewType( TheFamilyOfIntrinsicObjects,
              IsCapCategoryIntrinsicObjectRep and
              IsFinitelyPresentedModuleRep and
              IsHomalgRightObjectOrMorphismOfRightObjects
              );
    
    type_mor :=
      NewType( TheFamilyOfIntrinsicMorphisms,
              IsCapCategoryIntrinsicMorphismRep and
              IsMapOfFinitelyGeneratedModulesRep and
              IsHomalgRightObjectOrMorphismOfRightObjects
              );
    
    type_end :=
      NewType( TheFamilyOfIntrinsicMorphisms,
              IsCapCategoryIntrinsicMorphismRep and
              IsHomalgSelfMap and
              IsMapOfFinitelyGeneratedModulesRep and
              IsHomalgRightObjectOrMorphismOfRightObjects
              );
    
    A := IntrinsicCategory( A, type_obj, type_mor, type_end, INSTALL_TODO_LISTS_FOR_HOMALG_MORPHISMS );
    
    ## TODO: legacy
    SetFilterObj( A, IsHomalgCategory );
    A!.containers := rec( );
    
    etaSM := NaturalIsomorphismFromIdentityToStandardModuleRight( R );
    
    A!.IdSM := TurnAutoequivalenceIntoIdentityFunctorForHomalg( etaSM, A );
    
    etaZG := NaturalIsomorphismFromIdentityToGetRidOfZeroGeneratorsRight( R );
    
    A!.IdZG := TurnAutoequivalenceIntoIdentityFunctorForHomalg( etaZG, A );

    etaLG := NaturalIsomorphismFromIdentityToLessGeneratorsRight( R );
    
    A!.IdLG := TurnAutoequivalenceIntoIdentityFunctorForHomalg( etaLG, A );
    
    return A;
    
end );
