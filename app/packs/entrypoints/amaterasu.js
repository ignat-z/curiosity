require("@rails/ujs").start();
require('@hotwired/turbo-rails');

import "stylesheets/amaterasu";

import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

const application = Application.start();
const context = require.context("./controllers", true, /\.js$/);
application.load(definitionsFromContext(context));

document.documentElement.classList.replace("no-js", "js");
