# Latin Modern fonts for -*- Lout -*-.
# The original Computer Modern fonts do not have accented characters.

# Latin Modern Typewriter.

{ @FontDef
   @Tag { LMT-Base }
   @Family { LMT }
   @Face { Base }
   @Name { LMMono10-Regular }
   @Metrics { lmtt10.afm }
   @Mapping { LtLatin1.LCM }
   @Recode { Yes }
}

{ @FontDef
   # XXX: Just cheating to hide the lack of a `Bold' variant
   @Tag { LMT-Bold }
   @Family { LMT }
   @Face { Bold }
   @Name { LMMono10-Regular }
   @Metrics { lmtt10.afm }
   @Mapping { LtLatin1.LCM }
   @Recode { Yes }
}

{ @FontDef
   @Tag { LMT-Slope }
   @Family { LMT }
   @Face { Slope }
   @Name { LMMono10-Italic }
   @Metrics { lmtti10.afm }
   @Mapping { LtLatin1.LCM }
   @Recode { Yes }
}
