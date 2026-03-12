// ==UserScript==
// @name         GitHub Split Pulls Tab
// @namespace    https://danott.website
// @version      0.5.0
// @description  Replaces the "Pull requests" tab on GitHub repos with "Drafts" and "In Review" tabs
// @author       Dan Ott
// @match        https://github.com/*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function () {
  "use strict";

  async function fetchCount(href) {
    const resp = await fetch(href);
    const html = await resp.text();
    const match = html.match(/(\d+)\s+Open/);
    return match ? match[1] : null;
  }

  async function updateCounter(item, href) {
    const count = await fetchCount(href);
    const counter = item.querySelector("[data-component='counter']");
    if (!counter) return;
    if (!count || count === "0") {
      counter.remove();
      return;
    }
    const label = counter.querySelector("[data-variant]");
    if (label) label.textContent = count;
    const hidden = counter.querySelector("[class*='VisuallyHidden']");
    if (hidden) hidden.textContent = `\u00a0(${count})`;
    counter.style.display = "";
  }

  function splitPullsTab() {
    const repoBase = window.location.pathname.match(/^\/([^/]+\/[^/]+)/)?.[1];
    if (!repoBase) return;

    const pullsLink = document.querySelector(
      `a[href="/${repoBase}/pulls"][data-tab-item="pull-requests"]`
    );
    if (!pullsLink) return;

    const pullsItem = pullsLink.closest("li");
    if (!pullsItem || pullsItem.dataset.splitApplied) return;
    pullsItem.dataset.splitApplied = "true";

    const draftsItem = pullsItem.cloneNode(true);
    const reviewItem = pullsItem.cloneNode(true);

    for (const item of [draftsItem, reviewItem]) {
      const link = item.querySelector("a");
      link.removeAttribute("data-tab-item");
      link.removeAttribute("data-turbo-frame");
      link.removeAttribute("data-hotkey");
      link.setAttribute("data-split-tab", "true");
      link.removeAttribute("aria-current");
      const counter = item.querySelector("[data-component='counter']");
      if (counter) counter.style.display = "none";
    }

    draftsItem.querySelector("a").href = `/${repoBase}/pulls?q=is%3Apr+is%3Aopen+draft%3Atrue`;
    reviewItem.querySelector("a").href = `/${repoBase}/pulls?q=is%3Apr+is%3Aopen+draft%3Afalse`;

    const setText = (el, text) => {
      const span = el.querySelector("[data-component='text']");
      if (span) span.setAttribute("data-content", text);
      const walker = document.createTreeWalker(el, NodeFilter.SHOW_TEXT);
      let node;
      while ((node = walker.nextNode())) {
        if (node.textContent.includes("Pull requests")) {
          node.textContent = node.textContent.replace("Pull requests", text);
        }
      }
    };

    setText(draftsItem, "Drafts");
    setText(reviewItem, "In Review");

    pullsItem.replaceWith(draftsItem, reviewItem);

    for (const item of [draftsItem, reviewItem]) {
      const link = item.querySelector("a");
      updateCounter(item, link.href);
    }
  }

  function highlightActiveTab() {
    const links = document.querySelectorAll("a[data-split-tab]");
    if (!links.length) return;

    const path = window.location.pathname;
    const currentQ = path.endsWith("/pulls")
      ? new URLSearchParams(window.location.search).get("q")
      : null;

    for (const link of links) {
      const tabQ = new URL(link.href).searchParams.get("q");
      if (currentQ && currentQ === tabQ) {
        link.setAttribute("aria-current", "page");
      } else {
        link.removeAttribute("aria-current");
      }
    }
  }

  function update() {
    splitPullsTab();
    highlightActiveTab();
  }

  update();

  new MutationObserver(update).observe(document.body, {
    childList: true,
    subtree: true,
  });
})();
