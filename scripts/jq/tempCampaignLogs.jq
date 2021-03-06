# Gather campaign logs information
[
  .[]
  | {
      campaignId: .campaign.id,
      section: map(..
                    .effects?
                    | .[]?
                    | select(
                        ((.type=="campaign_log") or (.type=="campaign_log_count") or (.type=="campaign_log_cards"))
                        and .text
                        and (.cross_out != true)
                      )
                  )
              | group_by(.section)
              | .[]
              | { section: .[0].section, entries: map(. | { id: .id, text: .text }) | unique},
      supplies: map(.. .supplies? | .[]? ) | flatten
    }
]
| group_by(.campaignId)
| map({
        campaignId: .[0].campaignId,
        sections: map(.section),
        supplies: map(.supplies) | flatten | unique
      })
