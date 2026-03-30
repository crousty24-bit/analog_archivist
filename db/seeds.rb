# frozen_string_literal: true

def upsert_category(attributes)
  category = Category.find_or_initialize_by(slug: attributes.fetch(:slug))
  category.update!(attributes)
  category
end

def upsert_product(category:, attributes:)
  image_rows = attributes.delete(:images)
  specification_rows = attributes.delete(:specifications) || []

  product = Product.find_or_initialize_by(slug: attributes.fetch(:slug))
  product.category = category
  product.assign_attributes(attributes.except(:slug))
  product.save!

  product.product_images.destroy_all
  image_rows.each_with_index do |image_attributes, index|
    product.product_images.create!(
      role: image_attributes.fetch(:role),
      position: image_attributes.fetch(:position, index + 1),
      remote_url: image_attributes.fetch(:remote_url),
      alt_text: image_attributes[:alt_text]
    )
  end

  product.product_specifications.destroy_all
  specification_rows.each_with_index do |specification_attributes, index|
    product.product_specifications.create!(
      label: specification_attributes.fetch(:label),
      value: specification_attributes.fetch(:value),
      position: specification_attributes.fetch(:position, index + 1)
    )
  end

  product
end

categories = {
  "cat-trees" => upsert_category(
    slug: "cat-trees",
    name: "Cat Trees",
    hero_label: "Cat Trees",
    image_remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuDj49TuXgK3g9u8nblIL5UErA6N4e3FaJTT7I3-VP8cdeFHVgDklCGS_tQ8OEhSNCPLCd505rkUYeSJVCs1sYTl4OSfUUhqMtcdYgUgk2Mi1Yo1hW3H39WsxsmqHSHBno8Iu2TO5BLOlmnooF8US3EALlsqyqhPXvBxLMw2LezY5poj9cxio8LH1OAoXcG5kg06b-OL-wfAD8wA2UVULsGWyR8lGf2PFNJltac9gCEwgTWGXBLj877FmPXvVcFS2sbISvcqgjbqKdqy",
    image_alt_text: "Cat tree",
    sort_position: 1
  ),
  "pinball" => upsert_category(
    slug: "pinball",
    name: "Pinball",
    hero_label: "Mechanical Curiosities",
    image_remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuAH3NNWS0Sdg8OGKDL0u47VVpEd_vegnijNoiz5_zalfv5cHGwZiHRu0IvF0XAPNzEeL7yNKdSkFkcPcp4ENUnzVMMxm0rewJXznixXjei6VI6_cqH_K385UX2reeYo6ZvRhxBW-qZ2ZZ579UZsBOI9wV3LVdt-lWD8uZIzCDOIcmS-plUdIOhTwVj4HhLhpFdqFMoG50-Q-3npbefuwFL3BRRM9rZ5cHEJ0as_NuTyiwG6NAQlMLjnLW8gKb5ikKbPncfFvaEgqBpX",
    image_alt_text: "Vintage pinball machine",
    sort_position: 2
  ),
  "trading-cards" => upsert_category(
    slug: "trading-cards",
    name: "Trading Cards",
    hero_label: "Trading Cards",
    image_remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuBe-IirKbxXM-lHz5oh3vwnwmAPtFi97fD0yXv3_Y8jcHHaQkRdSQ5R-6e-kvMB3dnVylt-stjL9URtHuHCRn-qyHJ9d0l_lvMcRN1TQohAIpGNS67v9AKvk_8-hCIAPWRSK_qQreD-NKO-ZFg0GCFmAHBmoy9iGFmeAhmnXmibKDqw3agRWOIDk2MNyFKWSGkZHgO6QC_FB2BDOP2S_sF7LAu21F2s3dYhGJQRgDXUZkd4gLLup4251sxBClxSg2beJtycJg9tLu9K",
    image_alt_text: "Trading cards",
    sort_position: 3
  ),
  "oil-lamps" => upsert_category(
    slug: "oil-lamps",
    name: "Oil Lamps",
    hero_label: "Oil Lamps",
    image_remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuCaSL9fywGeo4Lq_O7bFXno7cuRT3iF3UQREVKsZRa0K_crEgLss1RPvQhSU1YErgfLSqight6CCpYi6UJyNFrlPA6SxOzFeSWuI3pAw4LTcvYe8w-RBE5jooz-iPe-gK_YUHeH6IxhTF56AUM-Cr2TNJRa2RFlKBTdyaqHYbvtUBEJu9RiBw4zyfHHxeUHAb39XsI_ZQKG-P-1R8M8GQ1-s104VWZiE8wc8NaY5e21_-4w_qiUVK0z3ep04JOqOFKO0-KlZCc4DyHY",
    image_alt_text: "Oil lamp",
    sort_position: 4
  ),
  "mechanical-curiosities" => upsert_category(
    slug: "mechanical-curiosities",
    name: "Mechanical Curiosities",
    hero_label: "Mechanical Curiosities",
    image_remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuBL_GtbKrnjdRn7IeNt8hwQSHgecWaGj5fIrfJSZMfktrq5fJyvaD4yujBbRGzDFz16jg9MDrBLMlE-_JpCG33w4Zee8ENI3BfRCVovPj8rLnVcNgnGprKy0Ef-j2HFDY2W8QhNS1t46rYZugCf7KnPR_oeccegWsK7CxA61JrqhWs8SRrw4I_xykaWGSYHXRo7FEgE3soc0WNXfBA3PxtK3PHATXwfQsGm1mrWsIVq_lmyTXDUMPNVlCjsiQTF0VsK-WVyQ_2znv70",
    image_alt_text: "Mid-century radio",
    sort_position: 99
  )
}

upsert_product(
  category: categories.fetch("pinball"),
  attributes: {
    slug: "bally-74-resurrection",
    title: "The Bally '74 Resurrection",
    price_cents: 485_000,
    availability: "1 of 1 in Stock",
    detail_body: "Fully restored to its mechanical prime, this unit features original hand-painted artwork and the legendary \"Silver Slugger\" solenoid upgrade. A masterclass in analog entertainment.",
    sort_position: 10,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuBc7H1VqfcshrBPX29--9k5-gJWFq99CrGmBKF4QNZ7GVah_T24ArnQiYfQtCKxcn6j5_0kGa_aJsceUsqgGNMUx8iZRrNWaTauSnQoL7jJ43xjaX7X9actRbF_BQeNs3Pshl17v0RBylDqPwALqLAXZnp9osCY8U8tOdinENKtUsPI-cNIppkwSy0voSyMqV5rOcGTE-a8yPuq1eQMhzIsEuNDwl0Qg1uE3B2E70AjrnThypeWzIdnpUFeWLbEb6JImie5G0U7muee",
        alt_text: "Bally 1974 Pinball"
      },
      {
        role: "hero",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuBc7H1VqfcshrBPX29--9k5-gJWFq99CrGmBKF4QNZ7GVah_T24ArnQiYfQtCKxcn6j5_0kGa_aJsceUsqgGNMUx8iZRrNWaTauSnQoL7jJ43xjaX7X9actRbF_BQeNs3Pshl17v0RBylDqPwALqLAXZnp9osCY8U8tOdinENKtUsPI-cNIppkwSy0voSyMqV5rOcGTE-a8yPuq1eQMhzIsEuNDwl0Qg1uE3B2E70AjrnThypeWzIdnpUFeWLbEb6JImie5G0U7muee",
        alt_text: "Bally 1974 Pinball"
      },
      {
        role: "gallery",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuDRDoDsS3JNq_nV3SANwn-bH3NjMhflqfUu0gtoVEpTg3iHdzxm-lzctqM0yzmxVWv7axLwktVwag13dn77s0ineSgnbdcUtRVC9DOIHd8pRln4ri96xtwKkqYtfhmtJ-DtKwnEYKasw8mMKDT48CrTEj44LLkyhITUfXfC7vC5XtV2Muo_5Z2cMIIiuWYuq6rXtvhVMsyKxoNNW9m40td6Oetso_cfcUOVE0O71x2jBBrrEkAT6V56LzOz5lsWAAKWqxbNR6Pnurl4",
        alt_text: "View 1"
      },
      {
        role: "gallery",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuCqGV_mB98Q6AIM-gnsJ2xjHDrCUdUtP4HXDeJ0eLdZDaJZocvPfZvj-q9YKw0RIWtP-LppVBPA3WWkx1t2weSWsZrg1HNKNVI2vLIu3nqNbtFQyRVVSJS5vYJNPeSYl4rxJH8zqJMAYd-4etkXuU9LXtjVXVx6IHaJrqN1j65xetYkO5XdeoXXgR29fo8UiFWCYSei8QCKUG1FfFiogR-u48VXtg9v13yEBLhrvApMnJjS8GMP-LpH3CZMbkTQqEWLk0XWP-MeNj1E",
        alt_text: "View 2"
      }
    ],
    specifications: [
      { label: "Origin", value: "Chicago, IL • 1974" },
      { label: "Condition", value: "Archive Grade A+" },
      { label: "Restoration Hours", value: "142 Professional Hours" }
    ]
  }
)

upsert_product(
  category: categories.fetch("cat-trees"),
  attributes: {
    slug: "aspen-cat-tower",
    title: "The Aspen Cat Tower",
    subtitle: "Natural Birch & Merino",
    material: "Natural Birch & Merino",
    short_description: "Natural Birch & Merino",
    price_cents: 64_000,
    sort_position: 100,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuAJzRrnCEoP7m1js2nfajluZ03eP1-459qA4vOlf-mmOMtRBB6YNkgdF0XsTEm7vVqZkk0ojEmIOvhFtbYae-NRlZgtIJbJzlzV4-Kb1F3Oe-oENa5iot2_RV3EmfHq2n--iiVvVK38I6DcrUA54VVcU6S0-i_fo5drNAUOT6hcX4O1W89kaasE9EAH4c2aP4r-KqE5Oqifd2KB6M46ObVEUUt-EDVthgPQU7Vbe1VtEvUtaF2Fvq4Xhpc28HklMJF7ID8kKbnKxhsW",
        alt_text: "The Aspen Cat Tower"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("oil-lamps"),
  attributes: {
    slug: "amber-victorian-sconce",
    title: "Amber Victorian Sconce",
    subtitle: "Hand-Blown Glass",
    material: "Hand-Blown Glass",
    short_description: "Hand-Blown Glass",
    price_cents: 32_000,
    sort_position: 101,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuCI2KZJih1uwG5xHXAqv7KYmH1rtJwsAqDRIPpw9YCvV-PjtyBOFkdArGxxV9RR5OGLJRlKHb_pGkLzcbXuAXnots51il2mWgzLszy5Izt1GI1NckAJ7p7zxFs6hVwDAVx5mCwiHqIzNLX53bX0-b3AY8M1bj9_WpQaYJ-NotRRduzVt8fXFgG_S1wrDZSu7isFXJrWchnYqX3OuU4BuGGHUUhEnk6jVBjvdAGCktLo97rt8pg__ynQKF3p74i0gjxRyLMsqfAK6OUX",
        alt_text: "Victorian Oil Lamp"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("trading-cards"),
  attributes: {
    slug: "base-set-rare-foil",
    title: "Base Set Rare Foil",
    subtitle: "PSA Graded Gem Mint 10",
    material: "PSA Graded Gem Mint 10",
    short_description: "PSA Graded Gem Mint 10",
    price_cents: 120_000,
    sort_position: 102,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuAwZXK2Vx26lSdMfsjD3AlNHFj94YjkYXbH5G4UaHQ0xy1A9h-ZzNXdZyTnv98BSALsv7pwQqq3qvr_Jq59yy3zBn8cYsy1feBMEDe7nUCXunj9AVu6WfmEG97Ii31s7H8pYyUkUqSoief37mRWBjefcJ0TFtcAi4c84AdetfD4_-MVfiYOZZw2MQcZPfkt_4ImkgkL3HcWQ7NIZDhSeS5qBA9e7DXVrB688V8dU1PookooVO049pal7H6kCtZRLLbA3GONWolYeSFb",
        alt_text: "Base Set Rare Foil"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("mechanical-curiosities"),
  attributes: {
    slug: "zenith-transoceanic",
    title: "The Zenith Transoceanic",
    subtitle: "Shortwave Receiver • 1956",
    short_description: "Shortwave Receiver • 1956",
    price_cents: 89_000,
    sort_position: 103,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuBL_GtbKrnjdRn7IeNt8hwQSHgecWaGj5fIrfJSZMfktrq5fJyvaD4yujBbRGzDFz16jg9MDrBLMlE-_JpCG33w4Zee8ENI3BfRCVovPj8rLnVcNgnGprKy0Ef-j2HFDY2W8QhNS1t46rYZugCf7KnPR_oeccegWsK7CxA61JrqhWs8SRrw4I_xykaWGSYHXRo7FEgE3soc0WNXfBA3PxtK3PHATXwfQsGm1mrWsIVq_lmyTXDUMPNVlCjsiQTF0VsK-WVyQ_2znv70",
        alt_text: "Mid-Century Radio"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("cat-trees"),
  attributes: {
    slug: "victorian-feline-tower",
    title: "The Victorian Feline Tower",
    archive_number: "#4021",
    price_cents: 124_000,
    badge: "Unique Piece",
    short_description: "Crafted from reclaimed cherry wood with hand-woven sisal accents and emerald velvet lounging tiers.",
    sort_position: 1,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuAgMCmgqGaFWMYfUP2nw5db06w9LE_bQHeB79TTRSeJJdpZUTl2xl4zooaxOQm1b8jiPhPJPwKI8cVwc1ogpexqfuWWo8pHPn_H66AryQ4zPFXnc4NV7rhyCll_cV373ScTvjW0T3pkg77yDn8KHlPV4Kj_n_dUeIwbkXSgb2Wo9YHeiOLx7T6Xzbdje8Cf5QvOzuYjYPl5lWWhUnCOxy2NBza4lBT34W2dD9vbJSTjAQlD8aypjZxMRmg6Vz3B1BCYit9BBA0xMHBd",
        alt_text: "Luxury cat tree"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("pinball"),
  attributes: {
    slug: "cosmic-voyager-1974",
    title: "The Cosmic Voyager (1974)",
    archive_number: "#8892",
    price_cents: 480_000,
    short_description: "A fully restored electro-mechanical marvel. Original glass, vibrant cabinet art, and a crisp chime system.",
    sort_position: 2,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuDFXJhlhCuTqdtxow_Kccep4DGmZn5gH31NyoPa8_R_buISNPyFMEzDOCESvCBuO1Ilv5esBpAoPle6Kjfv7Eo5QlySeTWfOe5AzHJp5ZuyMoWV1rIgaRC5aPoYiBu8W09sKFcThK-SsedUdlpgEc5Zt8ZrjjMAiDUO8JKytEoPZXsNqGXWWDMB4zg4P43uUehr9ACkKVcCnu8whqhxFQ_AkhvXdHYzYpUdZobsjMWu50XtIUjZzxMZqmDeb2sDEDHlxEYBgGOqGPOw",
        alt_text: "Classic pinball machine"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("trading-cards"),
  attributes: {
    slug: "gilded-monarch-set",
    title: "The Gilded Monarch Set",
    archive_number: "#1104",
    price_cents: 85_000,
    short_description: "A complete first-edition printing from the 1922 'Imperial' series. Mint condition, leather case included.",
    sort_position: 3,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuDoNAYxqDNUt2BaXv1Z7B1Qpusl4dzaodfKHpiheD7VXjaAGkaEBRoVYA_JuqECvKTGyRxz8l5AssEB8Y4b1_fEiH9utgd2IWLHmpiq5h1w8_ZD9CIgYMiVEC518wJ3YMn-7QDLsiISxIPsqEccrUohmp7LttOUWy-ji0pQakAu-dVHs5osdMDm-k-qe95PQgB3hK5LBNFtcmTsYtqfKHpoGOJ9YnlLmnrerXfIY_tiMTY0Gk9gRZqZya__af3XMBaYn_BkJ17mdylL",
        alt_text: "Rare trading cards"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("oil-lamps"),
  attributes: {
    slug: "admirals-beacon",
    title: "The Admiral's Beacon",
    archive_number: "#3321",
    price_cents: 32_000,
    short_description: "Solid marine brass with a hand-blown fluted chimney. Functional and atmospheric maritime heritage.",
    sort_position: 4,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuDIHILC0Ym9qE2kiSvcDClKufdHNdmn2r_AKrCIQ0zYc7v7pXuO3PQGgHKZ1_QbMMyDvH-PX4qgSwapu8ds4cg1D-TnBhqwIa16O7vZHnOzraqu_d5C1N3mZ2XKNfZedBjdhmJU2_fAAm2nxRhP7RXfOeAZm7N-MxLInbdXMUeNTgwQPbUDPN8Xohqe-BWdhQMAkvQypJtV2KZdKGpiXYoOQ__dLeu8Yu6jS-XpprPqBdcJj11887I1qrWIz9BQ1tydJXRPnMik7q3U",
        alt_text: "Brass oil lamp"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("cat-trees"),
  attributes: {
    slug: "palace-chaise",
    title: "The Palace Chaise",
    archive_number: "#4029",
    price_cents: 61_000,
    short_description: "For the feline of royal disposition. Wrought iron frame with gold leaf detailing.",
    sort_position: 5,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuDAdyagyc7RtUe9hPKjO5pZVkOuhR3GZuPMlKHTQADbP6zlUqDjdlLTO-QZ4xe7DIxiezthxX1z7TMT3GdVnvBy22HleW_vhvB6D8jvDaBb3J9nCA1kV5l_PuqrF5ivMz2fXUliiXxrDYKJ5LQ3FzyJzXXBR5iHATDxPzwfNs0ypCbFhPWUv--LA9Y1Sp1AwoY51dVBbVaeF_CT69nGN4mF4N6vndLO7n2OwTTiorBgkobb-vycj-CGfkb7YgF3jqbNvTRxsS8IIxSH",
        alt_text: "Antique cat furniture"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("oil-lamps"),
  attributes: {
    slug: "cerulean-glass-lanterns",
    title: "Cerulean Glass Lanterns",
    archive_number: "#3325",
    price_cents: 44_500,
    short_description: "A trio of late 19th-century lanterns featuring rare cobalt-stained reservoir glass.",
    sort_position: 6,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuBHAXRUVKUzRh0oip6MuBim_NS8ZozsQSpDO5x6JEpGSLojeGGp_Y1qUZhWmhT19UltbbGZKbjpDG7jo_bX4YVSxXxrvyqoxViGZFIyehTLPAYHYQR7rA0jDqKahQdcJ5KrChthkn_KeD0kbjJGbnhF3DKZD82M2OPqlz7rY4k3LVCUCFdWfmcMruOuaFlQ5Pt8JpoTru7pE8DathG3cdVojrRkQV8kW9M7e04OBGXe2cYQ0ZyufQK9dD-83wlnnzWeEyS_Kl983WVQ",
        alt_text: "Vintage lamp collection"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("pinball"),
  attributes: {
    slug: "solaris-pinball-cabinet",
    title: "The 1968 'Solaris' Pinball Cabinet",
    badge: "Archive Grade A+",
    availability: "One of three remaining in private circulation.",
    detail_quote: "\"A mechanical symphony of electromagnetic chimes and gravity. The Solaris was the last of the purely electromechanical giants, crafted before the silicon revolution took the soul out of the silver ball.\"",
    detail_body: "Acquired from a private collection in Lyon, this 1968 masterpiece has been meticulously preserved in a climate-controlled vault for four decades. The backglass art, a fever dream of mid-century cosmic optimism, remains vibrant with no flaking. Each bumper has been re-tensioned using period-accurate springs to maintain the authentic \"snap\" of the original gameplay.",
    story_title: "A Piece of Lost Leisure",
    story_body: "The Solaris cabinet represents a zenith in mechanical engineering. Unlike modern digital recreations, every sound in this machine is physical—metal striking metal, the hum of high-voltage transformers, and the physical kinetic feedback of the flippers. It requires a dialogue between player and machine, a tactile dance of nudging and timing that can never be replicated on a screen.",
    price_cents: 1_245_000,
    sort_position: 110,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuCUmdZsNHJ86960uMtJi9Sz8V3HXQ6p5rmiX69dd671IBOOhE4mdJ6QccFQFnWPSa0GpKxMPJ84mHPbgY8q1VBva_P-KY4uivliwdqxGfiXOCmOEAYQK8EgoDcO4qGAQM5ns4o24u5dsAlcdPtCJu6fNbId8gEFpSQci2PlpVKY2huTgfZLSal8DVHtt6nQZC-lDjzzEW2wNMGC7VhC6nqH2u75zTrXKnKqOZUA9BHcNwaVXwr8pQr3nuUNKS8nAp6tYboH73YOuXZA",
        alt_text: "Vintage Pinball Machine"
      },
      {
        role: "hero",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuCUmdZsNHJ86960uMtJi9Sz8V3HXQ6p5rmiX69dd671IBOOhE4mdJ6QccFQFnWPSa0GpKxMPJ84mHPbgY8q1VBva_P-KY4uivliwdqxGfiXOCmOEAYQK8EgoDcO4qGAQM5ns4o24u5dsAlcdPtCJu6fNbId8gEFpSQci2PlpVKY2huTgfZLSal8DVHtt6nQZC-lDjzzEW2wNMGC7VhC6nqH2u75zTrXKnKqOZUA9BHcNwaVXwr8pQr3nuUNKS8nAp6tYboH73YOuXZA",
        alt_text: "Vintage Pinball Machine"
      },
      {
        role: "gallery",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuDoUm__n4jziIyuDtc-tb02EH5K0e0LFYS4TCjI4NslT_STIjbZPv3ehhC10MYJPleHQcJ6q_wqstPbM9uFIhupzHQOoWpGRPlKSkyY2Jhf-S-cQ1uhp11mhv_HR6oGFDJGMjjv_CidvRxDzM0G0UioZ2tp2Cv-dk_QP_7iGD9EjHnrTt2ZFub1X-gSKYJV3Ilw-EVSWnk0tBbCibHGdOJjvVjBwfWYcu2ONpJSEraort71yKnZhxXyw_KbgA6XRdZzrGAO1QK4JuX1",
        alt_text: "Pinball Detail"
      },
      {
        role: "gallery",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuDIiFbWZ_2EVYpMoh1_K-7T29SEiYVR8avTdPyyv2OWC2XnFEQiF2k46LEnosUUDg7Rlm0-8UKCvWmqDUMV5mKQhnDKjazFOfuliB7H-Tvo8s4BCs_Ja_G_inul08AgIjhivC2r37K0PoGqsiXbAn29FqNDjctdrDgiD18k7KFdzTGbOxOsVLbBreIgmNx_eLmwKgSgGe3riu6wmzLvTI65F19Pat0Brj5CGVzEXdzZglehuMw3u3G7dcn5Wx-Lfj0WxDFC45nerPYy",
        alt_text: "Cabinet Art"
      },
      {
        role: "story",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuCU4w0Ic88Rzv2W8UGEICU13Suv4krHyuhxiLvZptowl9018J0Ii9Lx7tqU9yDdVrtkMte5w5IeiElH3FwuQJ6T4-6WovGpGX90hJKa5cz64Ar-a3fuzAW__OcXUApXm0Y6D3FmgGeD9yO7UFzwytBJN9WRiJm0U0TderL1XtnfYO5nW0JFHv92AjMzLpTVfdMx-6SVG75Qrwc_co1oyzF_JMiG2_IimYlMKW7nW55AdJ0LN2aUY8ZEwDJcBNWU_hfkSTmiFOxbb5Sq",
        alt_text: "Retro Arcade Atmosphere"
      }
    ],
    specifications: [
      { label: "Manufacturer", value: "Midway-Gottlieb & Co." },
      { label: "Movement Type", value: "Electromechanical / Chime Box" },
      { label: "Dimensions", value: "29\"W x 52\"D x 70\"H" },
      { label: "Restoration", value: "Unrestored / Original Lacquer" },
      { label: "Weight", value: "245 lbs" }
    ]
  }
)

upsert_product(
  category: categories.fetch("cat-trees"),
  attributes: {
    slug: "hand-carved-oak-cat-spire",
    title: "Hand-Carved Oak Cat Spire",
    sku: "#CT-992",
    price_cents: 34_500,
    sort_position: 120,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuCQfJTwPCZv0odA4YHshivIXGjfBE-OlPVT3XqmechQQCfrCyfaHcEeigkWNc6Gou64BeXWcfQ4MwnGeshyn6SU6qZIHvqt-xaYkznrpmTEpWlWnnxFwsu5xf9T_mtvNO52_rA8TyaywTFSxQajDZbqgM53kfSmHMT9SKw8TkRNxReeYMIBdFQWaJP-Dt9qyAWaiEPuD84wVZ5cWt7WP0_TbdJAX7BIHybESrvggtKOl7lYeb3NxtXTRiTG0t_wioLiHAmvohL2ezY2",
        alt_text: "Hand-Carved Oak Cat Spire"
      }
    ]
  }
)

upsert_product(
  category: categories.fetch("oil-lamps"),
  attributes: {
    slug: "victoria-era-brass-oil-lantern",
    title: "Victoria Era Brass Oil Lantern",
    sku: "#OL-412",
    price_cents: 12_800,
    sort_position: 121,
    images: [
      {
        role: "card",
        remote_url: "https://lh3.googleusercontent.com/aida-public/AB6AXuBwVCj14nc0Z9p4vlbX81-DZHVVvEYjLHvnk9MrSgyd_XtskIb2hJ6G7ojFLDDxM2o_2f0Qkht5Z1HQrqE53nrFv7bNtcOm7ZzqJP96NcVH3L703ZQuOr9Dl7bbqJ08V7Nck_4mS5Hbe5l_Ko2D7rZ13tqSijVGhDO8UZNP_xwhXVT7YkozyZ8_VughwCs_KAhOsHJtYiNtm7K5NksmfgsbRM5vUmg8siDGNVqvRDnhOYl6yv2vhTzsUSgitXrxdDL92pwnrAkwHBZn",
        alt_text: "Victoria Era Brass Oil Lantern"
      }
    ]
  }
)

puts "Seeded #{Category.count} categories, #{Product.count} products, #{ProductImage.count} product images, and #{ProductSpecification.count} product specifications."
