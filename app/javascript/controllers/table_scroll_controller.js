import { Controller } from "@hotwired/stimulus"

function supportsIntersectionObserver() {
  return (
    "IntersectionObserver" in window ||
    "IntersectionObserverEntry" in window ||
    "intersectionRatio" in window.IntersectionObserverEntry.prototype
  );
}

export default class extends Controller {
  static targets = [
    "navBar",
    "scrollArea",
    "column",
    "leftButton",
    "rightButton",
    "columnVisibilityIndicator",
  ];
  static classes = [
    "navShown",
    "navHidden",
    "buttonDisabled",
    "indicatorVisible",
  ];

  connect() {
    this.startObservingColumnVisibility();
  }

  disconnect() {
    this.stopObservingColumnVisibility();
  }

  startObservingColumnVisibility() {
    if (!supportsIntersectionObserver()) {
      console.warn(`This browser doesn't support IntersectionObserver`);
      return;
    }

    this.intersectionObserver = new IntersectionObserver(
      this.updateScrollNavigation.bind(this),
      {
        root: this.scrollAreaTarget,
        threshold: 0.99, // otherwise, the right-most column sometimes won't be considered visible in some browsers, rounding errors, etc.
      }
    );

    this.columnTargets.forEach((headingEl) => {
      this.intersectionObserver.observe(headingEl);
    });
  }

  stopObservingColumnVisibility() {
    if (this.intersectionObserver) {
      this.intersectionObserver.disconnect();
    }
  }

  updateScrollNavigation(observerRecords) {
    observerRecords.forEach((record) => {
      record.target.dataset.isVisible = record.isIntersecting;
    });

    this.toggleScrollNavigationVisibility();
    this.updateColumnVisibilityIndicators();
    this.updateLeftRightButtonAffordance();
  }

  toggleScrollNavigationVisibility() {
    const allColumnsVisible =
      this.columnTargets.length > 0 &&
      this.columnTargets[0].dataset.isVisible === "true" &&
      this.columnTargets[this.columnTargets.length - 1].dataset.isVisible ===
        "true";

    if (allColumnsVisible) {
      this.navBarTarget.classList.remove(this.navShownClass);
      this.navBarTarget.classList.add(this.navHiddenClass);
    } else {
      this.navBarTarget.classList.add(this.navShownClass);
      this.navBarTarget.classList.remove(this.navHiddenClass);
    }
  }

  updateColumnVisibilityIndicators() {
    this.columnTargets.forEach((headingEl, index) => {
      const indicator = this.columnVisibilityIndicatorTargets[index];

      if (indicator) {
        indicator.classList.toggle(
          this.indicatorVisibleClass,
          headingEl.dataset.isVisible === "true"
        );
      }
    });
  }

  updateLeftRightButtonAffordance() {
    const firstColumnHeading = this.columnTargets[0];
    const lastColumnHeading = this.columnTargets[this.columnTargets.length - 1];

    this.updateButtonAffordance(
      this.leftButtonTarget,
      firstColumnHeading.dataset.isVisible === "true"
    );
    this.updateButtonAffordance(
      this.rightButtonTarget,
      lastColumnHeading.dataset.isVisible === "true"
    );
  }

  updateButtonAffordance(button, isDisabled) {
    if (isDisabled) {
      button.setAttribute("disabled", "");
      button.classList.add(this.buttonDisabledClass);
    } else {
      button.removeAttribute("disabled");
      button.classList.remove(this.buttonDisabledClass);
    }
  }

  scrollLeft() {
    // scroll to make visible the first non-fully-visible column to the left of the scroll area
    let columnToScrollTo = null;
    for (let i = 0; i < this.columnTargets.length; i++) {
      const column = this.columnTargets[i];
      if (columnToScrollTo !== null && column.dataset.isVisible === "true") {
        break;
      }
      if (column.dataset.isVisible === "false") {
        columnToScrollTo = column;
      }
    }

    this.scrollAreaTarget.scroll(columnToScrollTo.offsetLeft, 0);
  }

  scrollRight() {
    // scroll to make visible the first non-fully-visible column to the right of the scroll area
    let columnToScrollTo = null;
    for (let i = this.columnTargets.length - 1; i >= 0; i--) {
      // right to left
      const column = this.columnTargets[i];
      if (columnToScrollTo !== null && column.dataset.isVisible === "true") {
        break;
      }
      if (column.dataset.isVisible === "false") {
        columnToScrollTo = column;
      }
    }

    this.scrollAreaTarget.scroll(columnToScrollTo.offsetLeft, 0);
  }
}
