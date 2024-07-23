namespace XRL.World.Parts {
  using System;
  using System.Linq;
  using System.Collections.Generic;

  using XRL.World.Tinkering;
  using XRL.UI;
  using XRL.Rules;

  [Serializable]
  public class PKMKT_ModApplicator : IPart {
    public const string NO_MOD_FOUND = "OH_GOD_OH_FUCK";

    public string ModPartName;
    // public string Sigil;

    public string RngAllowedTables;
    public string RngForceRarity;

    public bool SuppressModInDisplayName = false;

    public static string GetSigilsForModPart(string modPart) {
      var rng = Stat.GetSeededRandomGenerator("PKMKT_" + modPart);
      var okMakersMarkStrings = MakersMark.GetUsable(SkipUsed: false);
      var outs = Enumerable.Range(0, 3).Select(_ =>
          "{{Y|" + okMakersMarkStrings.GetRandomElement(rng) + "}}")
        .ToList();
      return String.Join("{{y|-}}", outs);
    }

    // NULLABLE
    public ModEntry GetModEntry() {
      if (this.ModPartName.IsNullOrEmpty()) {
        return null;
      } else {
        return ModificationFactory.ModsByPart.TryGetValue(this.ModPartName, out var it)
          ? it : null;
      }
    }

    public override bool WantEvent(int id, int cascade) {
      return id == ObjectCreatedEvent.ID
        || id == GetDisplayNameEvent.ID
        || id == GetShortDescriptionEvent.ID
        || id == InventoryActionEvent.ID
        || base.WantEvent(id, cascade);
    }

    public override bool HandleEvent(ObjectCreatedEvent ev) {
      if (this.ModPartName.IsNullOrEmpty()) {
        this.RngModPart();
      }

      return base.HandleEvent(ev);
    }

    public override bool HandleEvent(GetDisplayNameEvent ev) {
      if (ev.Understood()) {
        if (!this.SuppressModInDisplayName 
            && this.GetModEntry() is ModEntry entry) 
        {
          ev.AddTag("(" + entry.TinkerDisplayName + ")");
        }
      } else if (ev.Object.PartiallyUnderstood()) {
        // if (!this.Sigil.IsNullOrEmpty()) {
        //   ev.AddTag("(" + this.Sigil + ")");
        // }
      }
      return base.HandleEvent(ev);
    }

    public override bool HandleEvent(GetShortDescriptionEvent ev) {
      if (this.GetModEntry() is ModEntry entry) {
        ev.Postfix
          .Append("\nAdds item modification: ")
          .Append(ItemModding.GetModificationDescription(entry.Part, 0))
          // .Append("\n\nMarked with the sigil ")
          // .Append(this.Sigil)
          ;
      } else {
        ev.Postfix.Append("{{r|This modkit is}} {{R|BROKEN.}} (This is a bug. Please send the logs to petrakat7604 on the Caves of Qud discord.)");
      }

      return base.HandleEvent(ev);
    }

    public override bool HandleEvent(InventoryActionEvent ev) {
      if (ev.Command != "Apply")
        return base.HandleEvent(ev);

      if (!(this.GetModEntry() is ModEntry entry)) {
        ParentObject.Explode(20);
        return ev.Actor.Fail(ParentObject.Does("explode") + "!");
      }

      List<GameObject> okObjects = ev.Actor.Inventory.GetObjects()
        .Concat(ev.Actor.Body.GetEquippedObjects())
        .Where(go => go != ParentObject &&
          (!ParentObject.Understood() || ItemModding.ModificationApplicable(entry.Part, go)))
        .ToList();

      if (okObjects.Count == 0) {
        return ev.Actor.Fail("You do not have anything you can use " + ParentObject.the + " on.");
      }

      GameObject picked = PickItem.ShowPicker(okObjects,
        Style: PickItem.PickItemDialogStyle.SelectItemDialog,
        Actor: ev.Actor);
      if (picked == null) return false; // ???

      bool appliedOk = ItemModding.ApplyModification(picked, entry.Part, out var _, picked.GetTier());
      if (!appliedOk) {
        return ev.Actor.Fail("Nothing happens.");
      }

      if (ev.Actor.IsPlayer()) {
        Popup.Show("You mod your " + picked.BaseDisplayName + " to be " +
          entry.TinkerDisplayName + ".");
        ParentObject.MakeUnderstood();
      }
      ParentObject.Obliterate();

      return base.HandleEvent(ev);
    }

    private void RngModPart() {
      var okTables = this.SplitAllowTables();
      Dictionary<ModEntry, int> okMods = new Dictionary<ModEntry, int>();
      foreach (var modEntry in ModificationFactory.ModList) {
        var tablesOk = okTables.Length == 0
          || modEntry.TableList.Intersect(okTables).Any();
        var rarityOk = this.RngForceRarity.IsNullOrEmpty()
          || ModificationFactory.getRarityCode(this.RngForceRarity) == modEntry.Rarity;
        if (tablesOk && rarityOk) {
          okMods.Add(modEntry, ModificationFactory.getBaseRarityWeight(modEntry.Rarity));
        }
      }

      // looks like Dictionary<T, int> has a weighted picker extension
      var picked = okMods.GetRandomElement();
      if (picked == null) {
        UnityEngine.Debug.LogError("Could not generate a modkit with "
          + $"RngAllowedTables={this.RngAllowedTables}, "
          + $"RngForceRarity={this.RngForceRarity}");
        this.ModPartName = NO_MOD_FOUND;
      } else {
        this.ModPartName = picked.Part;
        // this.Sigil = GetSigilsForModPart(picked.Part);

        if (ParentObject.GetPart<Commerce>() is Commerce commerce) {
          commerce.Value *= picked.Value;
        }
      }
    }

    private string[] SplitAllowTables() => this.RngAllowedTables?.Split(",") ?? new string[0];
  }
}
