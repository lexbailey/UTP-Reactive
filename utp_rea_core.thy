theory utp_rea_core
  imports utp_designs utp utp_pred "Shallow-Expressions.Shallow_Expressions"
begin

alphabet 'e rea_vars = des_vars +
  wait :: bool
  tr   :: "'e list"

type_synonym ('t, '\<alpha>) rp = "('t, '\<alpha>) rea_vars_scheme"

type_synonym ('t,'\<alpha>,'\<beta>) rel_rp  = "('t,'\<alpha>) rea_vars_scheme \<leftrightarrow> ('t,'\<beta>) rea_vars_scheme"

type_synonym ('t, '\<alpha>) hrel_rp = "('t,'\<alpha>) rea_vars_scheme \<leftrightarrow> ('t,'\<alpha>) rea_vars_scheme"

translations
  (type) "('t,'\<alpha>) rp" <= (type) "('t, '\<alpha>) rea_vars_scheme"
  (type) "('t,'\<alpha>) rp" <= (type) "('t, '\<alpha>) rea_vars_ext"
  (type) "('t,'\<alpha>,'\<beta>) rel_rp" <= (type) "('t,'\<alpha>) rea_vars_scheme \<leftrightarrow> ('\<gamma>,'\<beta>) rea_vars_scheme"
  (type) "('t,'\<alpha>) hrel_rp"  <= (type) "('t,'\<alpha>) rea_vars_scheme \<leftrightarrow> ('\<gamma>,'\<beta>) rea_vars_scheme"

notation rea_vars.more\<^sub>L ("\<Sigma>\<^sub>R")

syntax
  "_svid_rea_alpha"  :: "svid" ("\<Sigma>\<^sub>R")

translations
  "_svid_rea_alpha" => "CONST rea_vars.more\<^sub>L"

declare des_vars.splits [alpha_splits del]
declare des_vars.splits [alpha_splits]
(*declare zero_list_def [upred_defs]
declare plus_list_def [upred_defs]*)
declare prefixE [elim]

abbreviation wait_f::"('t, '\<alpha>, '\<beta>) rel_rp \<Rightarrow> ('t, '\<alpha>, '\<beta>) rel_rp" ("_\<^sub>f" [1000] 1000)
where "wait_f R \<equiv> R\<lbrakk>false/wait\<^sup><\<rbrakk>"

abbreviation wait_t::"('t, '\<alpha>, '\<beta>) rel_rp \<Rightarrow> ('t, '\<alpha>, '\<beta>) rel_rp" ("_\<^sub>t" [1000] 1000)
  where "wait_t R \<equiv> R\<lbrakk>true/wait\<^sup><\<rbrakk>"

(*
syntax
  "_wait_f"  :: "logic \<Rightarrow> logic" ("_\<^sub>f" [1000] 1000)
  "_wait_t"  :: "logic \<Rightarrow> logic" ("_\<^sub>t" [1000] 1000)



translations
  "P \<^sub>f" \<rightleftharpoons> "CONST usubst (CONST subst_upd id\<^sub>s (CONST in_var CONST wait) false) P"
  "P \<^sub>t" \<rightleftharpoons> "CONST usubst (CONST subst_upd id\<^sub>s (CONST in_var CONST wait) true) P"
*)

definition lift_rea :: "('\<alpha> \<leftrightarrow>'\<beta>) \<Rightarrow> ('t, '\<alpha>, '\<beta>) rel_rp" ("\<lceil>_\<rceil>\<^sub>R") where
"\<lceil>P\<rceil>\<^sub>R \<equiv> P \<up> (\<Sigma>\<^sub>R\<^sup>2)"
term "\<lceil>P\<rceil>\<^sub>R"

definition drop_rea :: "('t, '\<alpha>, '\<beta>) rel_rp \<Rightarrow> ('\<alpha> \<leftrightarrow>'\<beta>)" ("\<lfloor>_\<rfloor>\<^sub>R") where
"\<lfloor>P\<rfloor>\<^sub>R \<equiv> P \<down> (\<Sigma>\<^sub>R\<^sup>2)"
term "\<lfloor>P\<rfloor>\<^sub>R"

abbreviation rea_pre_lift :: "_ \<Rightarrow> _" ("\<lceil>_\<rceil>\<^sub>R\<^sub><") where "\<lceil>n\<rceil>\<^sub>R\<^sub>< \<equiv> \<lceil>n\<^sup><\<rceil>\<^sub>R"


lemma unrest_ok_lift_rea [unrest]:
  "$ok\<^sup>< \<sharp> \<lceil>P\<rceil>\<^sub>R" "$ok\<^sup>> \<sharp> \<lceil>P\<rceil>\<^sub>R"
  unfolding lift_rea_def
  apply (simp add: unrest_aext_pred_lens)
  apply (simp add: unrest_aext_pred_lens) 
  done

(*Needs trace algebra*)
definition tcontr :: "'t \<Longrightarrow> ('t, '\<alpha>) rp \<times> ('t, '\<alpha>) rp" ("tt") where
  [lens_defs]:
  "tcontr = \<lparr> lens_get = (\<lambda> s. get\<^bsub>tr\<^sup>>\<^esub> s - get\<^bsub>tr\<^sup><\<^esub> s) , 
              lens_put = (\<lambda> s v. put\<^bsub>tr\<^sup>>\<^esub> s (get\<^bsub>tr\<^sup><\<^esub> s + v)) \<rparr>"

definition itrace :: "'t \<Longrightarrow> ('t, '\<alpha>) rp \<times> ('t, '\<alpha>) rp" ("\<^bold>i\<^bold>t") where
  [lens_defs]:
  "itrace = \<lparr> lens_get = get\<^bsub>tr\<^sup><\<^esub>, 
              lens_put = (\<lambda> s v. put\<^bsub>tr\<^sup>>\<^esub> (put\<^bsub>tr\<^sup><\<^esub> s v) v) \<rparr>"

syntax
  "_svid_tcontr"  :: "svid" ("tt")
  "_svid_itrace"  :: "svid" ("\<^bold>i\<^bold>t")
  "_utr_iter"     :: "logic \<Rightarrow> logic \<Rightarrow> logic" ("iter[_]'(_')")


translations
  "_svid_tcontr" == "CONST tcontr"
  "_svid_itrace" == "CONST itrace"
  "iter[n](P)"   == "CONST uop (CONST tr_iter n) P"
  